# Terraform State – Key Topics

##  Terraform State

* Terraform **stores information** about the infrastructure it manages in a file called `terraform.tfstate`.
* This file acts as a **mapping between your Terraform code and real-world cloud resources**.
* Without state, Terraform wouldn’t know what resources already exist or how to manage changes.

---

##  Drift

* **Drift** occurs when resources are **changed outside of Terraform** (e.g., manually deleting a VM in the GCP Console).
* Drift breaks sync between Terraform code and the actual infrastructure.
* Terraform detects drift when you run:

  ```bash
  terraform plan
  ```

---

##  Refresh

* Command:

  ```bash
  terraform refresh
  ```
* Updates the state file to match the real-world infrastructure.
* Does not modify resources → only syncs state.
* Example:

  * If a VM is deleted in Console → `refresh` updates state to show VM no longer exists.
  * Next `plan` → Terraform proposes to recreate the VM.

---

##  Taint / Untaint

* **Taint:** Forcefully mark a resource for recreation.

  ```bash
  terraform taint google_compute_instance.demo
  terraform apply
  ```
* **Untaint:** Undo taint before applying.

  ```bash
  terraform untaint google_compute_instance.demo
  ```
* Useful when:

  * Resource is unhealthy but config hasn’t changed.
  * You want a fresh replacement.

---

##  Removing a Resource from State (`state rm`)

* Removes resource from Terraform state **without touching it in the cloud**.

  ```bash
  terraform state rm google_compute_firewall.allow_ssh
  ```
* After removal:

  * Terraform no longer knows about this resource.
  * `plan` will try to **create it again**, which may cause a *name conflict*.
* Use carefully → state is the single source of truth.

---

##  Import

* Re-attaches an existing real-world resource back into state.

  ```bash
  terraform import google_compute_firewall.allow_ssh tf-state-demo-allow-ssh
  ```
* Use when:

  * A resource was manually created earlier.
  * You accidentally removed it from state (`state rm`).
* After import:

  * Resource is tracked in state again.
  * `plan` becomes clean (no drift).

---

##  Apply Target (`-target`)

* Run Terraform on a **specific resource** only.

  ```bash
  terraform apply -target=google_compute_instance.demo
  ```
* Good for:

  * Quick fixes.
  * Testing partial changes.


---

##  State File Security

* State may contain sensitive values (e.g., passwords, keys).
* Best practices:

  * Use **remote backends** (e.g., GCS bucket with IAM + versioning).
  * Enable **state locking** (prevents concurrent changes).
  * Never commit `terraform.tfstate` to Git.

---

#  Real-World Summary

* **State = Terraform’s truth.**
* **Drift** happens when infra changes outside Terraform → use `refresh` + `plan` to detect.
* **Taint** lets you replace a resource even if config didn’t change.
* **`state rm`** removes resources from state but not cloud → risky if not followed by `import`.
* **Import** brings unmanaged (or lost) resources back under Terraform control.
* **`-target`** focuses changes on one resource → use sparingly.
