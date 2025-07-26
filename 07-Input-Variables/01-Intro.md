###  **Terraform Input Variables – Summary**

**Purpose:**

* Input variables allow us to **customize Terraform modules/resources** without altering their source code.
* This makes the code **reusable** and **flexible**.

---

###  **Key Benefit**

* You can **reuse** Terraform configurations by simply changing the variable values instead of editing the code.

---


### Differnt ways to Declare and use Input Variables
1. `variables.tf`- Declares variables with default values
2. `Interactive-Prompt` - If no default values are defined, terraform will promput during `plan` or `apply`
3. `-var` flag - We can pass variables directly from cli using (`-var="varaibale_name=variable_value`)
4. `terraform.tfvars` - This is a common file for defining values, it will override the default values.
5. `--var-file` - Load specific `.tfvars` file manually. 
6. `Environment Variables` – this will load the values from envuronmental varaibles. Prefix with `TF_VAR_` to set (`export TF_VAR_region=us-central1`).

###  **Advanced Input Variable Usage**

7. **Complex Types** – Use `list`, `map`, `object`, etc., in variable definitions.
8. **Custom Validation** – Add rules to validate variable values.
9. **Sensitive Variables** – Use `sensitive = true` to avoid exposing in output/logs.
