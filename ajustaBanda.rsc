#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#   Calcula o tamanho da string tx/rx
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

foreach i in=[/queue simple find dynamic=yes]\
  do={

:local atributo

#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
########   Definindo o max-limit,    modelo: rx/tx   ########
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
     set atributo "max-limit"
     :local largura ([:len [/queue simple get value-name=$atributo  $i]] -1)
     :local ndivisor ($largura/2-1)
     :local vdivisor [:pick [/queue simple get value-name=$atributo  $i] $ndivisor ]
     :local tx [:pick [/queue simple get value-name=$atributo  $i] ($ndivisor+2) $largura]


#   Definir o Novo RX  <----------------------------|||
if ($vdivisor="k" or $vdivisor="M")\
do={

     :local rx
     if ($vdivisor="k")\
     do={
                              set rx [ (( $tx*2 )/5) ]

            }\
     else={ if ($vdivisor="M") do={
                              set rx [ (( $tx*2000 )/5) ] 
              }}
     :local maxlimit [ (((( $rx."k")."/").$tx).$vdivisor) ]
}
#   Definido o RX  <----------------------------|||

#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
########   Definindo o burst-limit,    modelo: rx/tx   ########
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
     set atributo "burst-limit"
     :local largura ([:len [/queue simple get value-name=$atributo  $i]] -1)
     :local ndivisor ($largura/2-1)
     :local vdivisor [:pick [/queue simple get value-name=$atributo  $i] $ndivisor ]
     :local tx [:pick [/queue simple get value-name=$atributo  $i] ($ndivisor+2) $largura]

#   Definir o Novo RX  <----------------------------|||
if ($vdivisor="k" or $vdivisor="M")\
do={

     :local rx
     if ($vdivisor="k")\
     do={
                              set rx [ (( $tx*2 )/5) ]

            }\
     else={ if ($vdivisor="M") do={
                              set rx [ (( $tx*2000 )/5) ] 
              }}
     :local burstlimit [ (((( $rx."k")."/").$tx).$vdivisor) ]
}
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
########   Definindo o burst-threshold,    modelo: rx/tx   ########
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
     set atributo "burst-threshold"
     :local largura ([:len [/queue simple get value-name=$atributo  $i]] -1)
     :local ndivisor ($largura/2-1)
     :local vdivisor [:pick [/queue simple get value-name=$atributo  $i] $ndivisor ]
     :local tx [:pick [/queue simple get value-name=$atributo  $i] ($ndivisor+2) $largura]

#   Definir o Novo RX  <----------------------------|||
if ($vdivisor="k" or $vdivisor="M")\
do={

     :local rx
     if ($vdivisor="k")\
     do={
                              set rx [ (( $tx*2 )/5) ]

            }\
     else={ if ($vdivisor="M") do={
                              set rx [ (( $tx*2000 )/5) ] 
              }}
    :local controle [ (((( $rx."k")."/").$tx).$vdivisor) ]
}

#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
########   Aplicando a regra
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

if ($vdivisor="k" or $vdivisor="M")\
do={

queue simple set $i \
limit-at=$maxlimit \
max-limit=$maxlimit \
burst-limit=$burstlimit \
burst-threshold=$controle

}


  }\
#   limit-at=820k/820k max-limit=820k/820k burst-limit=2050k/2050k burst-threshold=1107k/1107k
#  queue simple set max-limit=1M/2M <pppoe-lins> burst-limit=2M/4M limit-at=1M/2