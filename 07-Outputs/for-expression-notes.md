# Terraform `for` Expressions 

## What is a `for` Expression?

> A `for` expression in Terraform lets you **loop over a list or map** and **transform it** into another list or map.

It’s similar to a `for` loop in programming — but it’s used inside a `value =` block to **construct a new output**.

---

## Basic Syntax for Lists

```hcl
[for item in list : transformed_item]
```

| Part               | Meaning                           |
| ------------------ | --------------------------------- |
| `item`             | The current element in the list   |
| `list`             | The list you're looping through   |
| `transformed_item` | What you want each item to become |

---

### Example 1: List of VM Names

```hcl
output "vm_names" {
  value = [for instance in google_compute_instance.tf_gce_vm : instance.name]
}
```

🧩 Breakdown:

* `google_compute_instance.tf_gce_vm` is a **list of resources** (because we used `count`)
* We’re looping over each `instance` in that list
* For each `instance`, we extract its `.name`
* Final output is a **list of VM names**

---

## Syntax for Maps

```hcl
{for item in list : key => value}
```

| Part    | Meaning                        |
| ------- | ------------------------------ |
| `key`   | The map key (usually a string) |
| `value` | The map value                  |

---

### Example 2: Map of VM Name to IP

```hcl
output "vm_name_to_ip" {
  value = {
    for instance in google_compute_instance.tf_gce_vm :
    instance.name => instance.network_interface[0].access_config[0].nat_ip
  }
}
```

🧩 Breakdown:

* `for instance in ...` → loop through each VM instance
* `instance.name =>` → use the VM name as the **key**
* `...nat_ip` → use the external IP as the **value**

This gives a map like:

```hcl
{
  "vm-1" = "34.72.100.1"
  "vm-2" = "34.72.100.2"
}
```

---

## Syntax with Indexes

```hcl
{for index, item in list : index => transformed_value}
```

| Part    | Meaning                        |
| ------- | ------------------------------ |
| `index` | Position in the list (0, 1, 2) |
| `item`  | The actual item in the list    |

---

### Example 3: Index to VM Name

```hcl
output "index_to_name" {
  value = {
    for i, vm in google_compute_instance.tf_gce_vm :
    i => vm.name
  }
}
```

🧩 Result:

```hcl
{
  0 = "i27-webserver-1"
  1 = "i27-webserver-2"
}
```

---

## 🧪 Key Points to Understand

| Feature            | Purpose                                                  |
| ------------------ | -------------------------------------------------------- |
| `for item in list` | Loop through a list                                      |
| `: x => y`         | Create a map                                             |
| `[*].attr`         | Use if you just want a list of one field (no loop logic) |
| `for index, item`  | Gives access to position of item                         |

---