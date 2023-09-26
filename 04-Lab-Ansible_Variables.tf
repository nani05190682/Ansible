Ansible playbooks and variables:

---

### **Exercise 1: Basic Variable Usage**
**Task**: Create a playbook that prints a greeting message using a variable.

**Solution**:
```yaml
---
- hosts: localhost
  vars:
    greeting: "Hello, Ansible!"
  tasks:
    - name: Print greeting
      debug:
        msg: "{{ greeting }}"
```

---

### **Exercise 2: Variables in Tasks**
**Task**: Create a playbook that creates a user using a variable for the username.

**Solution**:
```yaml
---
- hosts: localhost
  vars:
    user_name: "john"
  tasks:
    - name: Create user
      user:
        name: "{{ user_name }}"
        state: present
```

---

### **Exercise 3: Using `vars_files`**
**Task**: Store variables in a separate file and use them in a playbook to print a message.

**vars.yml**:
```yaml
message: "External variables are cool!"
```

**Solution**:
```yaml
---
- hosts: localhost
  vars_files:
    - vars.yml
  tasks:
    - name: Print external message
      debug:
        msg: "{{ message }}"
```

---

### **Exercise 4: Command Line Variables**
**Task**: Override a playbook variable from the command line and print it.

**Solution**:
Playbook:
```yaml
---
- hosts: localhost
  vars:
    default_message: "Default Message"
  tasks:
    - name: Print message
      debug:
        msg: "{{ default_message }}"
```

Command:
```bash
ansible-playbook playbook.yml -e "default_message='Overridden Message'"
```

---

### **Exercise 5: Using Filters**
**Task**: Use a variable with a default filter to print a message.

**Solution**:
```yaml
---
- hosts: localhost
  tasks:
    - name: Print message with default
      debug:
        msg: "{{ unset_variable | default('This is a default message!') }}"
```

---

### **Exercise 6: Loops with Variables**
**Task**: Create a playbook that creates multiple users using a loop and a variable list.

**Solution**:
```yaml
---
- hosts: localhost
  vars:
    users:
      - alice
      - bob
  tasks:
    - name: Create multiple users
      user:
        name: "{{ item }}"
        state: present
      loop: "{{ users }}"
```

---

### **Exercise 7: Conditional Variables**
**Task**: Create a playbook that prints a message based on the value of a variable.

**Solution**:
```yaml
---
- hosts: localhost
  vars:
    environment: "production"
  tasks:
    - name: Print based on environment
      debug:
        msg: "You are in the {{ environment }} environment."
      when: environment == "production"
```

---

### **Exercise 8: Complex Variables**
**Task**: Define a dictionary of users and their UID. Create these users with their specified UID.

**Solution**:
```yaml
---
- hosts: localhost
  vars:
    users_dict:
      alice: 1001
      bob: 1002
  tasks:
    - name: Create users with UID
      user:
        name: "{{ item.key }}"
        uid: "{{ item.value }}"
        state: present
      loop: "{{ users_dict.items() }}"
```

---

### **Exercise 9: Variable in Jinja2 Template**
**Task**: Create a template for an Apache virtual host with a variable for the ServerName. Apply this template using a playbook.

**vhost.conf.j2**:
```
<VirtualHost *:80>
    ServerName {{ server_name }}
    DocumentRoot /var/www/{{ server_name }}
</VirtualHost>
```

**Solution**:
```yaml
---
- hosts: localhost
  vars:
    server_name: "example.com"
  tasks:
    - name: Apply vhost template
      template:
        src: vhost.conf.j2
        dest: "/etc/httpd/conf.d/{{ server_name }}.conf"
```

---

### **Exercise 10: Host-Specific Variables**
**Task**: Create a playbook that sets timezone based on a host-specific variable.

**Solution**:
**inventory.ini**:
```
[webservers]
web1.example.com timezone=America/New_York
web2.example.com timezone=America/Los_Angeles
```

**Playbook**:
```yaml
---
- hosts: webservers
  tasks:
    - name: Set timezone
      command: timedatectl set-timezone "{{ timezone }}"
```

---
