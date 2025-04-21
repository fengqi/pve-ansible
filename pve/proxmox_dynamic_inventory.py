#!/usr/bin/env python3
import subprocess
import json
import os
import sys

# 获取 PVE 数据
def get_pvesh_data(endpoint):
    try:
        result = subprocess.run(
            ["pvesh", "get", endpoint, "--output-format", "json", "--noborder"],
            capture_output=True,
            text=True,
            check=True
        )
        return json.loads(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error executing pvesh: {e}", file=sys.stderr)
        return []

# 生成动态 Inventory
def generate_inventory(status_filter=None):
    inventory = {"all": {"hosts": [], "children": ["vm", "lxc"]}, "vm": {"hosts": []}, "lxc": {"hosts": []}}

    # 获取 KVM 虚拟机
    vms = get_pvesh_data("/nodes/pve/qemu")
    for vm in vms:
        if status_filter and not vm.get("status").startswith(status_filter):
            continue
        vm_name = vm.get("name", f"vm-{vm['vmid']}")
        inventory["all"]["hosts"].append(vm_name)
        inventory["vm"]["hosts"].append(vm_name)

    # 获取 LXC 容器
    lxcs = get_pvesh_data("/nodes/pve/lxc")
    for lxc in lxcs:
        if status_filter and not lxc.get("status").startswith(status_filter):
            continue
        lxc_name = lxc.get("name", f"lxc-{lxc['vmid']}")
        inventory["all"]["hosts"].append(lxc_name)
        inventory["lxc"]["hosts"].append(lxc_name)

    # 为 LXC 组添加 ansible_connection 配置（作用于所有 lxc 容器）
    #inventory["lxc"]["ansible_connection"] = "lxc"

    return inventory

# 获取单个主机的详细信息
def get_host_info(host):
    # 获取主机相关信息
    host_info = {}

    # 获取 KVM 虚拟机信息
    vms = get_pvesh_data("/nodes/pve/qemu")
    for vm in vms:
        vm_name = vm.get("name", f"vm-{vm['vmid']}")
        if vm_name == host:
            host_info = {
                "name": vm_name,
                "vmid": vm["vmid"],
                "status": vm["status"],
                "cpu": vm["cpu"],
                "memory": vm["maxmem"]
            }
            break

    # 获取 LXC 容器信息
    if not host_info:
        lxcs = get_pvesh_data("/nodes/pve/lxc")
        for lxc in lxcs:
            lxc_name = lxc.get("name", f"lxc-{lxc['vmid']}")
            if lxc_name == host:
                host_info = {
                    "name": lxc_name,
                    "vmid": lxc["vmid"],
                    "status": lxc["status"],
                    "cpu": lxc["cpu"],
                    "memory": lxc["maxmem"]
                }
                break

    if not host_info:
        print(f"Host '{host}' not found.", file=sys.stderr)
        sys.exit(1)

    return host_info

if __name__ == "__main__":
    # 支持通过环境变量传入过滤条件，如 STATUS=running
    status_filter = os.getenv("STATUS", None)

    # 解析传入的参数
    if len(sys.argv) > 1:
        if sys.argv[1] == "--list":
            # 生成整个 Inventory
            inventory = generate_inventory(status_filter)
            print(json.dumps(inventory, indent=2))

        elif sys.argv[1] == "--host11" and len(sys.argv) > 2:
            # 显示单独主机的信息
            host = sys.argv[2]
            host_info = get_host_info(host)
            print(json.dumps(host_info, indent=2))

        else:
            print("Invalid arguments", file=sys.stderr)
            sys.exit(1)

    else:
        print(json.dumps({}, indent=2))

