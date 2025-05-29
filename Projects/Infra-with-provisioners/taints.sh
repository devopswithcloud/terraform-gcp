#!/bin/bash
for instance in $(terraform state list | grep -i 'google_compute_instance.tf-vm-instance'); do
    echo "Tainting instance: $instance"
    terraform taint $instance
done
