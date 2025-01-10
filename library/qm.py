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
        module.fail_json(msg=f"Command failed: {e.stderr.strip()}", cmd=cmd)

def get_vmid(module, name):
    cmd = "qm list"
    output = run_command(module, cmd)

    id_name_map = {}
    for line in output.splitlines()[1:]:  # 跳过表头
        parts = line.split()
        if len(parts) >= 2:
           id_name_map[parts[1]] = parts[0]  # Name -> VMID

    if name in id_name_map:
        return id_name_map[name]
    else:
        module.fail_json(msg=f"Command failed: {cmd}", cmd=cmd)

def start(module, vmid):
    cmd = f"qm start {vmid}"
    extraArgs = module.params['extra_args']
    if extraArgs:
        cmd += f" {extraArgs}"

    result = run_command(module, cmd)
    module.exit_json(changed=True, msg=f"Command {cmd} executed successfully.", output=result)

def shutdown(module, vmid):
    cmd = f"qm shutdown {vmid}"
    extraArgs = module.params['extra_args']
    if extraArgs:
        cmd += f" {extraArgs}"

    result = run_command(module, cmd)
    module.exit_json(changed=True, msg=f"Command {cmd} executed successfully.", output=result)

def main():
    module_args = dict(
        cmd=dict(type='str', required=True),
        host=dict(type='str', required=True),
        extra_args=dict(type='str', default=None)
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=False
    )

    host = module.params['host']
    vmid = get_vmid(module, host)
    cmd = module.params['cmd']
    match cmd:
        case "start":
            start(module, vmid)
        case _:
            module.fail_json(msg=f"Unknown command: {cmd}")

if __name__ == "__main__":
    main()
