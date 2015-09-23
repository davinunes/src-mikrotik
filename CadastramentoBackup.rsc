#--------------------------------------------------------------------------------------------------------#
#    Monte a Lista de Usuarios Conectados Via radius
#--------------------------------------------------------------------------------------------------------#
:local conectados;
set conectados [ppp active find where radius=no]
#--------------------------------------------------------------------------------------------------------#
#    Pra cada Item da Lista de Conectados
#--------------------------------------------------------------------------------------------------------#
:foreach i in=[$conectados] do={
:put $i
#--------------------------------------------------------------------------------------------------------#
#    Define o Login
#--------------------------------------------------------------------------------------------------------#
:local nome [/ppp active get value-name=name number=$i]
:put $nome
#--------------------------------------------------------------------------------------------------------#
#    Verifica se está cadastrado
#--------------------------------------------------------------------------------------------------------#
:local teste [/ppp secret find name=$nome]
#--------------------------------------------------------------------------------------------------------#
#    Se não tiver cadastrado, cadastre
#--------------------------------------------------------------------------------------------------------#
:if ($teste="") do={
#--------------------------------------------------------------------------------------------------------#
#    Encontra o Perfil de Banda
#--------------------------------------------------------------------------------------------------------#
:local interface ("<pppoe-" . $nome . ">")
:put $interface
put [queue simple print where name=$interface]
# rate burst media time priority rate-min
:local taxa [queue simple get [/queue simple find where name=$interface] max-limit]
:local bonus [queue simple get [/queue simple find where name=$interface] burst-limit]
:local media [queue simple get [/queue simple find where name=$interface] burst-threshold]
:local tempo [queue simple get [/queue simple find where name=$interface] burst-time]
:local prioridade [queue simple get [/queue simple find where name=$interface] priority]
:local minimo [queue simple get [/queue simple find where name=$interface] limit-at]
:local perfil ($taxa . " " . $bonus . " " . $media . " " . $tempo . " " . $prioridade . " " . $minimo)
:put $perfil
:local seperfil [/ppp profile find name=$perfil]
if ($seperfil="") do={
# Cria o Perfil
/ppp profile add name=$perfil rate-limit=$perfil only-one=yes local-address=172.16.5.1
}
#--------------------------------------------------------------------------------------------------------#
#    Busca IP Local e Remoto
#--------------------------------------------------------------------------------------------------------#
:local ipremoto [ /ppp active get value-name=address number=$i ]
:put "Buscando IP Remoto"
:put $ipremoto
#--------------------------------------------------------------------------------------------------------#
#    Adiciona o Nome nos Secrets
#--------------------------------------------------------------------------------------------------------#
/ppp secret add name=$nome password=$nome service=pppoe \
profile=$perfil comment="Cadastrado pelo Script" disabled=yes \
remote-address=$ipremoto
}
}
#-------------------------------------------------------------------------------------------------------#
ppp secret rem [/ppp secret find name=""]