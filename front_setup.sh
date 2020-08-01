install_and_build_frontend() {

        cd /home/Java/
        sudo su
        sudo git clone https://github.com/protos-kr/final_project
        cd final_project/
        sudo sed -i -e "s|https://fierce-shore-32592.herokuapp.com|http://$ext_ip:8080|g" /home/Java/final_project/src/app/services/token-interceptor.service.ts
        sudo curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
        sudo yum clean all && sudo yum makecache fast
        sudo yum install -y gcc-c++ make
        sudo yum install -y nodejs
        sudo npm install -g @angular/cli@7.0.7
        sudo npm install --save-dev  --unsafe-perm node-sass

        sudo npm install
        sudo rm -rf package-lock.json
        sudo ng build --prod
        sleep 5

}

setup_virtual_host() {


        setenforce 0
        sudo yum install httpd -y
        sudo systemctl enable httpd
        sudo systemctl start httpd
        sudo mkdir /var/www/eSchool
        sudo cp -r /home/Java/final_project/dist/eSchool/* /var/www/eSchool
        sudo cp /home/Java/final_project/.htaccess /var/www/eSchool/

        sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled /var/log/httpd/eSchool
        sudo echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
        sudo ln -s /etc/httpd/sites-available/eSchool.conf /etc/httpd/sites-enabled/eSchool.conf


sudo cat <<_EOF > /etc/httpd/sites-available/eSchool.conf
<VirtualHost *:80>
    #    ServerName www.example.com
    #    ServerAlias example.com
    DocumentRoot /var/www/eSchool
    ErrorLog /var/log/httpd/eSchool/error.log
    CustomLog /var/log/httpd/eSchool/requests.log combined
    <Directory /var/www/eSchool/>
            AllowOverride All
    </Directory>
</VirtualHost>
_EOF


      sudo chown -R apache:apache -R /var/www/eSchool/
        sudo chmod 766 -R /var/www/eSchool/
        sudo systemctl restart httpd

}

install_and_build_frontend
setup_virtual_host
