# pve-ansible
Managing PVE using Ansible
使用 Ansible 管理PVE

## 功能列表
- 批量开关机
- 批量更新系统
- 往LXC内部推送文件
- 在LXC内部执行命令

## 运行环境

- 在pve主机上运行
- ansible
- python3

## 扩展使用示例

1. 在lxc上部署、更新prometheus

```bash
ansible-playbook -i pve apps_prometheus.yml
```

2. 批量更新所有的 LXC、VM，limit是可选的

```bash
STATUS=running ansible-playbook -i pve update.yml --limit lxc
STATUS=running ansible-playbook -i pve update.yml --limit vm
```

3. 在lxc、vm上执行脚本

```bash
ansible-playbook -i pve on-remote.yml --limit gitea
```
4. 批量关机，limit是可选的

```bash
STATUS=running ansible-playbook -i pve shutdown.yml --limit lxc
STATUS=running ansible-playbook -i pve shutdown.yml --limit vm
```
