from flask import (
    Flask,
    request,
    jsonify,
    render_template,
    redirect,
    url_for,
    session,
    flash,
    send_from_directory,
)
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_wtf.csrf import CSRFProtect  # Web Templates Form
from flask_uploads import UploadSet, configure_uploads, ALL
from datetime import datetime
import pytz
import os
from form import TaskForm, LoginForm, UserForm, RegistrationForm, UpdateProfileForm
from models import db, Task, User
from werkzeug.utils import secure_filename
from werkzeug.datastructures import FileStorage  # 수정된 부분
from werkzeug.security import generate_password_hash, check_password_hash
import pymysql
from config import Config

pymysql.install_as_MySQLdb()

app = Flask(__name__)
app.config.from_object(Config)  # Config 클래스를 사용하여 설정을 로드합니다


db.init_app(app)
migrate = Migrate(app, db)
csrf = CSRFProtect(app)

# Upload configuration
files = UploadSet("files", ALL)
configure_uploads(app, files) # flask application과 UploadSet을 연결


# Jinja2 템플릿 필터 정의
def todate(value, format="%Y-%m-%d"):
    return datetime.strptime(value, format).date()


app.jinja_env.filters["todate"] = todate


@app.before_request
def create_admin():
    if not User.query.filter_by(username="admin").first():
        admin_user = User(username="admin", email="admin@example.com", is_admin=True)
        admin_user.set_password("admin_password")
        db.session.add(admin_user)
        db.session.commit()


@app.route("/task_ease_redirect")
def task_ease_redirect():
    if session.get("user_id"):
        return redirect(url_for("task_list"))
    else:
        return redirect(url_for("index"))


@app.route("/register", methods=["GET", "POST"])
def register():
    form = RegistrationForm()
    if form.validate_on_submit():

        # 사용자 이름 중복 확인
        existing_user_username = User.query.filter_by(
            username=form.username.data
        ).first()
        if existing_user_username:
            flash(
                "Username already taken. Please choose a different username.", "danger"
            )
            return render_template("register.html", form=form)

        # 이메일 중복 확인
        existing_user = User.query.filter_by(email=form.email.data).first()
        if existing_user:
            flash("Email already registered. Please use a different email.", "danger")
            return render_template("register.html", form=form)

        new_user = User(
            username=form.username.data, email=form.email.data, is_admin=False
        )
        new_user.set_password(form.password.data)
        db.session.add(new_user)
        db.session.commit()
        flash("You are now registered!", "success")
        return redirect(url_for("login"))
    return render_template("register.html", form=form)


@app.route("/login", methods=["GET", "POST"])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user and user.check_password(form.password.data):
            session["user_id"] = user.id
            session["username"] = user.username
            session["is_admin"] = user.is_admin
            flash("Login successful!", "success")
            return redirect(url_for("task_list"))
        flash("Invalid username or password.", "danger")
    return render_template("login.html", form=form)


@app.route("/logout")
def logout():
    session.clear()
    flash("You have been logged out.", "success")
    return redirect(url_for("login"))


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/task_list")
def task_list():
    if "user_id" not in session:
        return redirect(url_for("login"))
    tasks = Task.query.filter_by(user_id=session["user_id"]).all()
    current_date = datetime.utcnow().date()  # 현재 날짜를 설정합니다.
    tasks_with_info = []
    for task in tasks:
        task_info = {
            "id": task.id,
            "title": task.title,
            "contents": task.contents,
            "input_date": task.input_date,
            "due_date": task.due_date,
            "completion_date": task.completion_date,
            "days_remaining": None,
            "status": "미완료",
            "file_path": task.file_path,  # 파일 경로 추가
        }
        if task.completion_date:
            days_remaining = (task.due_date - task.completion_date).days
            task_info["days_remaining"] = days_remaining
            if days_remaining > 0:
                task_info["status"] = "조기 완료"
            elif days_remaining == 0:
                task_info["status"] = "제 시간에 완료됨"
            else:
                task_info["status"] = f"마감일 초과: {abs(days_remaining)}일"
        else:
            # 마감일과 현재 날짜를 비교하여 상태 설정
            days_remaining = (task.due_date - current_date).days
            task_info["days_remaining"] = days_remaining
            if days_remaining >= 0:
                task_info["status"] = "완료 예정"
            else:
                task_info["status"] = "기한 초과"
        tasks_with_info.append(task_info)
    return render_template(
        "task_list.html", tasks=tasks_with_info, current_date=current_date
    )


@app.route("/add_task", methods=["GET", "POST"])
def add_task():
    if "user_id" not in session:
        return redirect(url_for("login"))
    form = TaskForm()
    if form.validate_on_submit():
        title = form.title.data
        contents = form.contents.data

        # 한국 시간으로 현재 날짜 설정
        kst = pytz.timezone("Asia/Seoul")
        input_date = datetime.now(kst).date()

        due_date = form.due_date.data
        completion_date = (
            form.completion_date.data if form.completion_date.data else None
        )
        new_task = Task(
            title=title,
            contents=contents,
            input_date=input_date,
            due_date=due_date,
            completion_date=completion_date,
            user_id=session["user_id"],
        )

        # 파일 업로드 처리
        if form.file.data and isinstance(form.file.data, FileStorage):
            filename = files.save(form.file.data)
            new_task.file_path = filename
        db.session.add(new_task)
        db.session.commit()
        flash("Task added successfully!", "success")
        return redirect(url_for("task_list"))
    csrf_token = form.csrf_token._value()
    return render_template("add_task.html", form=form, csrf_token=csrf_token)


@app.route("/edit/<int:task_id>", methods=["GET", "POST"])
def edit_task(task_id):
    if "user_id" not in session:
        return redirect(url_for("login"))
    task = Task.query.get_or_404(task_id)
    if task.user_id != session["user_id"]:
        flash("You are not authorized to edit this task.", "danger")
        return redirect(url_for("index"))
    form = TaskForm(obj=task)
    if request.method == "POST" and form.validate_on_submit():
        task.title = form.title.data
        task.contents = form.contents.data
        task.due_date = form.due_date.data
        task.completion_date = (
            form.completion_date.data if form.completion_date.data else None
        )
        # 파일 업로드 처리
        if form.file.data and isinstance(form.file.data, FileStorage):
            # 기존 파일 삭제
            if task.file_path:
                file_path = os.path.join(
                    app.config["UPLOADED_FILES_DEST"], task.file_path
                )
                if os.path.exists(file_path):
                    os.remove(file_path)
            # 새 파일 저장
            filename = files.save(form.file.data)
            task.file_path = filename

        # 기존 파일 삭제 체크박스 처리
        if "remove_file" in request.form:
            if task.file_path:
                file_path = os.path.join(
                    app.config["UPLOADED_FILES_DEST"], task.file_path
                )
                if os.path.exists(file_path):
                    os.remove(file_path)
                task.file_path = None
        db.session.commit()
        flash("Task edited successfully!", "success")
        return redirect(url_for("task_list"))
    csrf_token = form.csrf_token._value()

    current_date = datetime.utcnow().date()  # 현재 날짜를 설정합니다.
    task_due_date = task.due_date
    completion_date = task.completion_date if task.completion_date else None
    return render_template(
        "edit_task.html",
        form=form,
        csrf_token=csrf_token,
        task=task,  # 여기에 task 변수를 추가합니다.
        current_date=current_date,  # 현재 날짜를 템플릿으로 전달
    )


@app.route("/delete/<int:task_id>")
def delete_task(task_id):
    if "user_id" not in session:
        return redirect(url_for("login"))
    task = Task.query.get_or_404(task_id)
    if task.user_id != session["user_id"]:
        flash("You are not authorized to delete this task.", "danger")
        return redirect(url_for("index"))
    if task.file_path:
        file_path = os.path.join(app.config["UPLOADS_DEFAULT_DEST"], task.file_path)
        if os.path.exists(file_path):
            os.remove(file_path)
    db.session.delete(task)
    db.session.commit()
    flash("Task deleted successfully!", "success")
    return redirect(url_for("task_list"))

# send_from_directory : 지정된 디렉토리에서 파일을 찾아 전송
@app.route("/download/<filename>")
def download_file(filename):
    if "user_id" not in session:
        return redirect(url_for("login"))
    file_path = os.path.join(app.config["UPLOADED_FILES_DEST"], filename)
    if os.path.exists(file_path):
        return send_from_directory(app.config["UPLOADED_FILES_DEST"], filename)
    else:
        flash("File not found.", "danger")
        return redirect(url_for("task_list"))


@app.route("/profile", methods=["GET", "POST"])
def profile():
    if "user_id" not in session:
        return redirect(url_for("login"))

    user = db.session.get(User, session["user_id"])
    form = UpdateProfileForm(obj=user)
    if form.validate_on_submit():
        user.username = form.username.data
        user.email = form.email.data
        if form.password.data:
            user.set_password(form.password.data)
        db.session.commit()
        flash("Profile updated successfully!", "success")
        return redirect(url_for("profile"))

    return render_template("profile.html", form=form)


@app.route("/delete_account", methods=["POST"])
def delete_account():
    if "user_id" not in session:
        return redirect(url_for("login"))

    user = db.session.get(User, session["user_id"])
    db.session.delete(user)
    db.session.commit()
    session.clear()
    flash("Account deleted successfully!", "success")
    return redirect(url_for("register"))


@app.route("/admin/delete/<int:user_id>")
def admin_delete_user(user_id):
    if "user_id" not in session or not session.get("is_admin"):
        return redirect(url_for("login"))
    user = db.session.get(User, user_id) or abort(404)
    db.session.delete(user)
    db.session.commit()
    flash("User deleted successfully!", "success")
    return redirect(url_for("admin"))


@app.route("/admin")
def admin():
    if "user_id" not in session or not session.get("is_admin"):
        return redirect(url_for("login"))
    users = User.query.all()
    return render_template("admin.html", users=users)


@app.route("/admin/add", methods=["GET", "POST"])
def add_user():
    if "user_id" not in session or not session.get("is_admin"):
        return redirect(url_for("login"))
    form = UserForm()
    if form.validate_on_submit():
        # 이메일 중복 확인
        existing_user = User.query.filter_by(email=form.email.data).first()
        if existing_user:
            flash("Email already registered. Please use a different email.", "danger")
            return render_template("user_form.html", form=form, title="Add New User")
        new_user = User(
            username=form.username.data,
            email=form.email.data,
            is_admin=form.is_admin.data,
        )
        new_user.set_password(form.password.data)
        db.session.add(new_user)
        db.session.commit()
        flash("User added successfully!", "success")
        return redirect(url_for("admin"))
    return render_template("user_form.html", form=form, title="Add New User")


@app.route("/admin/edit/<int:user_id>", methods=["GET", "POST"])
def edit_user(user_id):
    if "user_id" not in session or not session.get("is_admin"):
        return redirect(url_for("login"))
    user = db.session.get(User, user_id) or abort(404)
    form = UserForm(obj=user)

    if form.validate_on_submit():
        user.username = form.username.data
        user.email = form.email.data
        user.is_admin = form.is_admin.data
        if form.password.data:
            user.set_password(form.password.data)
            db.session.commit()
            flash("User updated successfully!", "success")
            return redirect(url_for("admin"))

    else:
        flash(
            "Form validation failed. Please check your input and try again.", "danger"
        )
    return render_template("user_form.html", form=form, title="Edit User")


@app.route("/admin/delete/<int:user_id>")
def delete_user(user_id):
    if "user_id" not in session or not session.get("is_admin"):
        return redirect(url_for("login"))
    user = db.session.get(User, user_id) or abort(404)
    db.session.delete(user)
    db.session.commit()
    flash("User deleted successfully!", "success")
    return redirect(url_for("admin"))


# 과제 준수 분석 경로 추가
@app.route("/admin/analysis")
def admin_analysis():
    users = User.query.all()
    user_analysis = []
    current_date = datetime.utcnow().date()

    for user in users:
        tasks = Task.query.filter_by(user_id=user.id).all()
        total_tasks = len(tasks)
        tasks_on_time = sum(
            1
            for task in tasks
            if task.completion_date
            and task.due_date
            and task.completion_date <= task.due_date
        )
        tasks_overdue = sum(
            1
            for task in tasks
            if (
                task.completion_date
                and task.due_date
                and task.completion_date > task.due_date
            )
            or (
                not task.completion_date
                and task.due_date
                and task.due_date < current_date
            )
        )
        compliance_rate = (tasks_on_time / total_tasks * 100) if total_tasks > 0 else 0

        user_analysis.append(
            {
                "username": user.username,
                "total_tasks": total_tasks,
                "tasks_on_time": tasks_on_time,
                "tasks_overdue": tasks_overdue,
                "compliance_rate": round(compliance_rate, 2),
            }
        )

    return render_template("admin_analysis.html", user_analysis=user_analysis)


if __name__ == "__main__":
    app.run(debug=True)
