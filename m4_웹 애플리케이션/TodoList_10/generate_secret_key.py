import secrets

def generate_secret_key():
    return secrets.token_hex(24)

secret_key = generate_secret_key()
print(f"SECRET_KEY = '{secret_key}'")
