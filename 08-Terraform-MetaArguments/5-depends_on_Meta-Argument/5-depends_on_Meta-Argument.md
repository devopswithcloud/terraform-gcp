# Terraform `depends_on` – Real Failure Simulation with Static IP and VM


## What is depends_on in Terraform?
Terraform normally **figures out the order** in which resources should be created, based on implicit references (like IDs, names, etc.).

> But sometimes, you want to tell Terraform explicitly:

“Don’t create this resource until that one is completely ready.”

That’s where depends_on comes in.
---

## Scenario

- Create a Service Account
- Simulate a delay in IAM propagation using `null_resource`
- Dynamically construct the service account email using `project_id`
- Assign it to a GCE VM **without** `depends_on` → it fails
- Then fix it by using `depends_on`

---

## Step 1: Define Variables

```hcl
variable "project_id" {
  type    = string
  default = "silver-tempo-455118-a5"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "service_account_id" {
  type    = string
  default = "i27-demo-sa"
}
```

---

## Step 2: Create the Service Account with `depends_on` to simulate IAM delay

```hcl
resource "google_service_account" "i27_sa" {
  account_id   = var.service_account_id
  display_name = "Demo SA for VM usage"
  depends_on = [ 
    null_resource.delay_sa_ready
   ]
}
```

---

## Step 3: Simulate Delay 

```hcl
resource "null_resource" "delay_sa_ready" {
  provisioner "local-exec" {
    command = "echo 'Simulating IAM delay...' && sleep 30"
  }
}
```

---

## Step 4: Create VM WITHOUT `depends_on` (Fails Intermittently)

```hcl
resource "google_compute_instance" "i27_vm_fail" {
  name         = "i27-vm-fail"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  service_account {
    email  = "${var.service_account_id}@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  tags = ["ssh-tag"]
}
```

💥 This may fail with an error like:

```
Error: The resource 'projects/.../serviceAccounts/...' is not ready
```

---

## Step 5: Fix It With `depends_on`

```hcl
resource "google_compute_instance" "i27_vm_fixed" {
  name         = "i27-vm-fixed"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  service_account {
    email  = "${var.service_account_id}@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  tags = ["ssh-tag"]

  depends_on = [
    google_service_account.i27_sa,
    null_resource.delay_sa_ready
  ]
}
```

---

## Summary

| Problem                                  | Fix                |
|------------------------------------------|---------------------|
| VM starts before SA is usable            | Add `depends_on`    |
| IAM delay causes deployment error        | Use `null_resource` |
| Dynamic email with project_id formatting | ✅ Works cleanly     |
