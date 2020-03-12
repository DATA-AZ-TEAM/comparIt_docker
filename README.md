# Compar-it 

ComparIt est un outil de comparaison de produits qui permet d'integrer des modeles de produits non fixés. Il dispose d'Api d'insertion de produits  

Techniquement, on s'appuie sur plusieures briques qu'il faut reussir a présenter de facon uniforme:  
1. Un front singlepageapp (Angular 8)
2. Une Api de services (Springboot Java)
3. Une brique de collecte des analytics (Matomo)

# Configuration Docker du produit ComparIt

Ces 3 briques sont présentées par un conteneur chapeau Nginx (reverse-proxy) qui s'assure de proxyfier les flux sans que ces conteneurs de necessite d'etre exposés a l'internet  
Tous les flux transitent par NGINX  

###Packages OS requis si vous ne disposez pas deja de docker sur la machine (ubuntu 18.04)  
`sudo ./install_dependancies.sh`  

Ajouter votre utilisateur au groupe docker  
`sudo usermod -aG docker $USER` ou `sudo vim /etc/group`  

redemarrer le serveur pour verifier que docker demarre autmatiquement avec le serveur et que vous disposiez des bon droits docker a la reconnexion  
`sudo reboot`  

il est necessaire de customiser plsieurs fichiers de configuration pour y declarer les URLS du site web, configurer les comptes de BDD, d'analytics....
liste des fichiers a customiser:
* docker-compose.yml(configuration des conteneurs necessaires au projet)
* nginx.conf (configuration du reverse proxy)
* environment.json (indique au Front les urls des services)

Vous pouvez substituer automatiquement le contenu des fichiers de configuration: 

`sed -i 's/SERVER_HOSTNAME/myhostname.example.com/g' docker-compose.yml environment/environment.json environment/environment.json nginx.conf`

ou faire les modifications manuelement dans les fichiers suivants:   
`vim nginx.conf`  
`vim docker-compose.yml`  
`vim environment/environment.json`  

### Les variables du docker-compose.yml:  

* compare-it-back: API SPRINGBOOT

| Command | Description |
| --- | --- |  
|  DATABASE_PORT | Le port de connexion mysql8 |
|  DATABASE_XPORT | Le port de connexion xdevapi mysql8 dédié a la recupération typée Documents |
|  DATABASE_HOST | Le nom du conteneur base de donnée |
|  DATABASE_USERNAME | Le compte de connexion a la base |
|  DATABASE_PASSWORD | Le mot de passe de connexion a la database |
|  DATABASE_NAME | La database name |
|  HIBERNATE_DDL_AUTO| Hibernate, mode de création ou mise a jour du modele de donnée au démarrage de l'instance |
|  LOG_LEVEL | Configuration du niveau de trace de la JVM |
|  DATABASE_LOG_LEVEL | Configuration du niveau de trace de la partie Hibernate persistance SGBD |
|  SENDGRID_API_KEY | L'envoi de mail via SENDGRID necessite la configuration d'une apikey |

 * matomo: Conteneur Analytique (recoit les sollicitations des utilisateurs)

| Command | Description |
| --- | --- |
|  MARIADB_HOST | Le nom du conteneur base de donnée |
|  MARIADB_PORT_NUMBER | Le port de connexion mysql8 |
|  MATOMO_DATABASE_NAME | La database name |
|  MATOMO_DATABASE_USER | Le compte de connexion a la base |
|  MATOMO_DATABASE_PASSWORD | Le mot de passe de connexion a la database |
|  MATOMO_USERNAME | Le compte admin matomo |
|  MATOMO_PASSWORD | Le mot de passe du compte admin Matomo |
|  MATOMO_WEBSITE_NAME  | Le nom du site surveillé par Matomo |
|  MATOMO_WEBSITE_HOST | L'url écoutée par matomo |

Lancement de ComparIT  
`cd comparIt_docker/`  
`docker-compose up -d`

## Envie de charger des produits?

Connectez vous a la page: http://myhostname.example.com

| User | Password |
| --- | --- |  
|admin@test.fr|test|

Vous pouvez charger les produits via url:   
Utilisez l'Api de Pokemons pour tester avec des données:  
https://pokemon-type-msn-tp3.herokuapp.com/pokemon-flat/

# A ne réaliser qu'en vue d'une configuration HTTPS SSL
## Configuration DNS

L'alias DNS a été pris en charge par cloudflare

recuperer le certificat letsencruypt relatif

il faut installer certbot et le plugin pip cloudflare 

>msn@vml2:~$ cat conf_https/certbot_generator.sh 
>certbot certonly \
>  --dns-cloudflare \
>  --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
>  -d comparit.fr \
>  -d www.comparit.fr \
>  -d back.comparit.fr \
>  -d analytics.comparit.fr

les cles générées peuvent etre utilisées dans la configuration nginx pour assurer la securisation SSL

le fichier nginx.conf.ssl peut etre customisé et remplacer le fichier nginx.conf

