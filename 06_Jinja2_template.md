# Ansible
---

UseCases for Jinja2 Template:
---

 When applied within a Linux environment, Ansible with Jinja2 templating offers a myriad of use cases. Here are 10 specific examples:

1. **System Configuration Files**: Customize `/etc` system configurations like `/etc/hosts` or `/etc/sysctl.conf`. For instance, you might want different sysctl settings for web servers versus database servers.

2. **SSH Server Configurations**: Modify the `/etc/ssh/sshd_config` file to ensure consistent SSH configurations. This could include specifying allowed ciphers, disabling root login, or specifying which users can log in.

3. **Cron Jobs**: Automate the creation of cron jobs by using templates. For example, generate nightly backup jobs, log rotation, or cleanup tasks depending on the server role.

4. **Network Interface Files**: Dynamically create or modify network interface configuration files like `/etc/network/interfaces` (for Debian/Ubuntu) or scripts under `/etc/sysconfig/network-scripts/` (for Red Hat/CentOS).

5. **User Profiles and Bashrc**: Customize `.bashrc`, `.bash_profile`, or other shell initialization files based on user roles or specific requirements.

6. **Logrotate Configurations**: Configure how different logs are rotated by templating `/etc/logrotate.conf` or files under `/etc/logrotate.d/`.

7. **Nginx/Apache Virtual Hosts**: Create virtual host configurations for web servers like Nginx or Apache. Based on variables, you can define server names, root directories, SSL certificates, etc.

8. **Motd (Message of the Day)**: Customize the `motd` (message displayed after login) based on the server's purpose, warnings, or any other required information.

9. **Automount Configurations**: If using `autofs`, you can use templates to generate `/etc/auto.master` and other automount maps, allowing you to control how and where filesystems are mounted dynamically.

10. **Security Settings**: Configure security modules like SELinux or AppArmor. For instance, generate specific SELinux policies or AppArmor profiles depending on the services running on a server.

For all these use cases, by leveraging Ansible's capabilities with the flexibility of Jinja2 templates, system administrators can ensure that configurations across Linux servers are consistent, scalable, and maintainable.

Modifying "/etc/hosts" entry in Linux
---

Certainly! Let's consider customizing the `/etc/hosts` file as an example. 

### Jinja2 Template (`hosts.j2`)

We're making a simple template where we add a couple of custom hostnames to the `/etc/hosts` file:

```jinja2
# /etc/hosts managed by Ansible
127.0.0.1   localhost

{% for host in custom_hosts %}
{{ host.ip }}   {{ host.name }}
{% endfor %}
```

This template will iterate over a list of custom hosts and add them to the hosts file.

### Ansible Playbook

Now let's create an Ansible playbook (`update_hosts.yml`) that uses this template to modify `/etc/hosts`:

```yaml
---
- name: Update /etc/hosts
  hosts: all
  become: yes  # Required to modify system files
  vars:
    custom_hosts:
      - { name: 'myapp.local', ip: '192.168.1.10' }
      - { name: 'database.local', ip: '192.168.1.11' }

  tasks:
    - name: Update hosts file using Jinja2 template
      template:
        src: hosts.j2
        dest: /etc/hosts
        owner: root
        group: root
        mode: '0644'
```

The playbook defines a list of `custom_hosts` with their names and IPs, and the `template` module is then used to render the Jinja2 template and overwrite `/etc/hosts`.

To run the playbook, you'd use:

```bash
ansible-playbook -i inventory_file update_hosts.yml
```

Replace `inventory_file` with the path to your Ansible inventory. 

**Note**: This example overwrites the existing `/etc/hosts`. In a real-world scenario, you'd likely want to consider existing content, back up the current file, or have other safeguards to prevent loss of data.


Example2:
---

Automating the creation of cron jobs using Jinja2 templates with Ansible can be a clean way to manage and deploy scheduled tasks across systems. Here's how you can achieve that:

### 1. Create the Jinja2 Template

First, create a Jinja2 template for the cron jobs. Let's call it `cron_jobs.j2`.

```jinja2
# Cron jobs managed by Ansible

{% for job in cron_tasks %}
{{ job.schedule }} {{ job.user }} {{ job.command }}
{% endfor %}
```

In this template, `cron_tasks` is a list containing the cron schedule, the user who will run the command, and the command itself.

### 2. Create the Ansible Playbook

Now, let's create an Ansible playbook that uses this template to populate a cron file in the cron.d directory:

```yaml
---
- name: Manage cron jobs
  hosts: all
  become: yes  # Required to modify system cron jobs
  vars:
    cron_tasks:
      - { schedule: '0 0 * * *', user: 'root', command: '/path/to/backup_script.sh' }
      - { schedule: '0 1 * * 7', user: 'username', command: '/path/to/weekly_task.sh' }

  tasks:
    - name: Set cron jobs using the Jinja2 template
      template:
        src: cron_jobs.j2
        dest: /etc/cron.d/managed_by_ansible
        owner: root
        group: root
        mode: '0644'
      notify: Restart cron

  handlers:
    - name: Restart cron
      service:
        name: cron
        state: restarted
```

In this playbook:

- We define the cron jobs we want to automate in the `cron_tasks` variable.
- The `template` module then uses the Jinja2 template to create a file in `/etc/cron.d/`.
- We add a handler to restart the cron service (this might be optional depending on the system, but it's a good practice to ensure the new cron jobs are recognized).

### 3. Running the Playbook

Execute the Ansible playbook:

```bash
ansible-playbook -i inventory_file manage_cron.yml
```

Replace `inventory_file` with the path to your Ansible inventory, and `manage_cron.yml` with whatever you name the playbook.

**Note**: Always be careful when modifying cron jobs, especially at the system level. Test your changes on a non-production system first.


Customizing User Profile
---

Customizing the `.bashrc` or `.bash_profile` using Ansible with Jinja2 templates is a common task when setting up user environments. Let's walk through how you can achieve this.

### 1. Create the Jinja2 Template

Let's start with the `.bashrc` file. We'll create a Jinja2 template named `bashrc.j2`.

```jinja2
# .bashrc managed by Ansible

# Source global definitions (default .bashrc content)
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

{% if custom_alias %}
# Custom aliases
{% for alias, command in custom_alias.items() %}
alias {{ alias }}="{{ command }}"
{% endfor %}
{% endif %}

{% if custom_env %}
# Custom environment variables
{% for key, value in custom_env.items() %}
export {{ key }}="{{ value }}"
{% endfor %}
{% endif %}
```

This template allows us to add custom aliases and environment variables.

### 2. Create the Ansible Playbook

Now, create an Ansible playbook, let's call it `customize_bash.yml`.

```yaml
---
- name: Customize .bashrc
  hosts: all
  become: no  # It's for a user environment
  vars:
    custom_alias:
      ll: 'ls -la'
      ldir: 'ls -d */'
    custom_env:
      EDITOR: 'vim'
      MY_VAR: 'SomeValue'

  tasks:
    - name: Set custom .bashrc using the Jinja2 template
      template:
        src: bashrc.j2
        dest: "~/.bashrc"  # Using tilde to denote user's home directory
        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"
        mode: '0644'
```

This playbook defines some custom aliases and environment variables, and then applies the `.bashrc` using our Jinja2 template.

### 3. Running the Playbook

Execute the Ansible playbook:

```bash
ansible-playbook -i inventory_file customize_bash.yml
```

Replace `inventory_file` with the path to your Ansible inventory.

**Note**:

1. The above example overwrites the `.bashrc` file. Depending on your needs, you might want to append to the file or take other precautions.
2. A similar approach can be used for `.bash_profile`. Depending on the user's shell and system configuration, either `.bashrc` or `.bash_profile` (or both) might be sourced on login. Make sure to target the right file for your needs.
3. Always test on a non-production user environment first to ensure you get the desired results.

