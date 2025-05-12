
# 🪟 Terraform Installation on Windows

This guide walks you through installing Terraform on a Windows machine.

---

## 📥 Step 1: Download Terraform

1. Go to the official Terraform download page:  
   👉 [https://developer.hashicorp.com/terraform/install](https://developer.hashicorp.com/terraform/install)
2. Choose **Windows (amd64)**.
3. Download the `.zip` file.

---

## 📂 Step 2: Extract and Move

1. Unzip the file to extract `terraform.exe`.
2. Move the `terraform.exe` to a permanent folder, e.g., `C:\terraform`.

---

## ⚙️ Step 3: Set Environment Variable

1. Open **Start Menu** → Search for `Environment Variables`.
2. Click **Environment Variables** → Under *System Variables*, select **Path** → Click **Edit**.
3. Click **New**, and add the path where `terraform.exe` is located (e.g., `C:\terraform`).
4. Click **OK** on all dialogs.

---

## ✅ Step 4: Verify the Installation

Open **Command Prompt** (`cmd`) and run:

```bash
terraform version
```

You should see output showing the installed Terraform version.

---

## 🧪 Test Command

```bash
terraform --help
```

If it shows available commands, Terraform is ready!

---

---

## 🚀 You're ready to start Terraforming on Windows!
