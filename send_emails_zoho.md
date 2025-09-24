# Zoho SMTP Email Sender Script

This script sends personalized emails using **Zoho SMTP** with
credentials loaded from a JSON file and an email template.

------------------------------------------------------------------------

## Python Script

``` python
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import json

SMTP_SERVER = "smtppro.zoho.in"
SMTP_PORT = 465          # SSL
SMTP_USER = "yourmail@zohomail.com"
SMTP_PASS = "your_app_password"  # Use Zoho App Password

USERS_FILE = "users.json"
TEMPLATE_FILE = "template.txt"

with open(USERS_FILE, "r", encoding="utf-8") as f:
    users = json.load(f)

with open(TEMPLATE_FILE, "r", encoding="utf-8") as f:
    template = f.read()

with smtplib.SMTP_SSL(SMTP_SERVER, SMTP_PORT) as server:
    server.login(SMTP_USER, SMTP_PASS)

    for email, info in users.items():
        name = email.split("@")[0]
        body = template.format(name=name, email=info["username"], password=info["password"])

        msg = MIMEMultipart()
        msg["From"] = SMTP_USER
        msg["To"] = email
        msg["Subject"] = "Your Account Credentials"
        msg.attach(MIMEText(body, "plain"))

        try:
            server.sendmail(SMTP_USER, email, msg.as_string())
            print(f"[SUCCESS] Mail sent to {email}")
        except Exception as e:
            print(f"[FAILED] Could not send mail to {email}: {e}")
```

------------------------------------------------------------------------

## Example `users.json`

``` json
{
  "ram@cs.edu": {
    "username": "ram@cs.edu",
    "password": "0Wgs8E^*k"
  },
  "vignesh@cs.edu": {
    "username": "vignesh@cs.edu",
    "password": "!:Z0,C3p6"
  }
}
```

------------------------------------------------------------------------

## Example `template.txt`

    Hi {name},

    Your username is {email} and password {password}.

    Please download and install the application from the following link to improve work productivity:

    https://gofil/7q6/4ch

    Once installed, open the application and enter your credentials.

------------------------------------------------------------------------

✅ Replace `yourmail@zohomail.com` and `your_app_password` with your
Zoho account details.\
✅ Make sure to generate an **App Password** in Zoho if you have 2FA
enabled.
