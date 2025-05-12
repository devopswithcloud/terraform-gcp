
# 🐧 Terraform Installation on Linux (Ubuntu/Debian)

This guide explains how to install Terraform on a Linux system using the official HashiCorp repository.

---

## 📥 Step 1: Update System

```bash
sudo apt update && sudo apt install -y gnupg software-properties-common curl
```

---

## 🔑 Step 2: Add HashiCorp GPG Key

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

---

## 📦 Step 3: Add HashiCorp APT Repository

```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

---

## 📦 Step 4: Install Terraform

```bash
sudo apt update
sudo apt install terraform
```

---

## ✅ Step 5: Verify Installation

```bash
terraform version
```

You should see the installed version of Terraform.

---

## 🧪 Test the Command

```bash
terraform --help
```

This should list all available Terraform commands.

---

## 🚀 Ready to Use

Terraform is now installed and ready to use on your Linux machine!
