#!/usr/bin/python

import os
import subprocess
from ansible.module_utils.basic import AnsibleModule

def run_command(module, cmd):
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            text=True,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        module.fail_json(msg=f"Command failed: {e.stderr.strip()}", output=f"Running command: {cmd} failed")

def get_vmid(module, name):
    cmd = "pct list"
    output = run_command(module, cmd)

    id_name_map = {}
    for line in output.splitlines()[1:]:  # 跳过表头
        parts = line.split()
        if len(parts) >= 2:
           id_name_map[parts[2]] = parts[0]  # Name -> VMID

    if name in id_name_map:
        return id_name_map[name]
    else:
        module.fail_json(msg=f"VM not found: {name}", output=f"VM {name} not found. Run 'pct list' to see available VMs.")

def get_shell(module, vmid):
    cmd = f"pct exec {vmid} -- getent passwd root"
    result = run_command(module, cmd)

    user_info = result.split(":")[-1]
    shell = user_info.split("/")[-1]

    return shell

def file_exists(module, vmid, file_path):
    cmd = f"pct exec {vmid} -- test -f {file_path}"
    try:
        subprocess.check_call(cmd, shell=True)
        return True
    except subprocess.CalledProcessError:
        return False

def push(module, vmid):
    src = module.params['src']
    dest = module.params['dest']


    if not os.path.isfile(src):
        module.fail_json(msg=f"Source file {src} does not exist.")

    cmd = f"pct push {vmid} {src} {dest}"

    extraArgs = module.params['extra_args']
    if extraArgs:
        cmd += f" {extraArgs}"

    result = run_command(module, cmd)
    module.exit_json(changed=True, msg=f"File {src} successfully pushed to {vmid}:{dest}.", output=result)

def exec(module, vmid):
    extraArgs = module.params['extra_args']

    shell = get_shell(module, vmid)
    if file_exists(module, vmid, extraArgs):
        extraArgs = f"-- {shell} {extraArgs}"
    else:
        extraArgs = f"-- {shell} -c '{extraArgs}'"

    cmd = f"pct exec {vmid} {extraArgs}"
    result = run_command(module, cmd)
    module.exit_json(changed=True, msg=f"Command {cmd} executed successfully.", output=result)

def start(module, vmid):
    cmd = f"pct start {vmid}"
    extraArgs = module.params['extra_args']
    if extraArgs:
        cmd += f" {extraArgs}"

    result = run_command(module, cmd)
    module.exit_json(changed=True, msg=f"Command {cmd} executed successfully.", output=result)

def shutdown(module, vmid):
    cmd = f"pct shutdown {vmid}"
    extraArgs = module.params['extra_args']
    if extraArgs:
        cmd += f" {extraArgs}"

    result = run_command(module, cmd)
    module.exit_json(changed=True, msg=f"Command {cmd} executed successfully.", output=result)

def main():
    module_args = dict(
        cmd=dict(type='str', required=True),
        host=dict(type='str', required=True),
        src=dict(type='str', default=None),
        dest=dict(type='str', default=None),
        extra_args=dict(type='str', default=None)
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=False
        # add_file_common_args=True
    )

    # 调试用
    # file_args = module.load_file_common_arguments(module.params)
    # module.fail_json(msg=f"Debug args", output=module.params)

    host = module.params['host']
    vmid = get_vmid(module, host)
    cmd = module.params['cmd']
    match cmd:
        case "push":
            push(module, vmid)
        case "exec":
            exec(module, vmid)
        case "start":
            start(module, vmid)
        case "shutdown":
            shutdown(module, vmid)
        case _:
            module.fail_json(msg=f"Unknown command: {cmd}")

if __name__ == "__main__":
    main()
