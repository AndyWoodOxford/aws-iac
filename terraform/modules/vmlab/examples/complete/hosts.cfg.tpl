[${host_group}]
%{ for ip in ipv4s ~}
${ip}
%{ endfor ~}
