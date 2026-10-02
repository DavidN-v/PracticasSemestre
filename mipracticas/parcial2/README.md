# Parcial 2 - Servicios Telematicos (codigo 22502608)

Configuraciones entregadas en `config/`:

| Archivo | Maquina | Funcion |
|---|---|---|
| before.rules | srv1-22502608 (192.168.40.30 / 192.168.50.3) | UFW y DNAT: 21 y 50000:50010 hacia 192.168.50.2, y 2222 hacia el 22 |
| vsftpd.conf | srv2-22502608 (192.168.50.2) | FTPS explicito, TLS forzado, pasivo 50000-50010 con pasv_address |
| sshd_config | srv2-22502608 | SFTP con Match User, ChrootDirectory e internal-sftp |
| resolved.conf | cliente-22502608 (192.168.40.31) | DNS sobre TLS (DoT) con systemd-resolved |

No se incluyen claves privadas (.key).
