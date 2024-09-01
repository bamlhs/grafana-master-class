#!/bin/bash

cat << 'EOF' > /home/vagrant/create_todo.sh
#!/bin/bash

# Navigate to Laravel application directory
cd /var/www/html/todo

# Loop to create 10 todo
for i in {1..10}
do
    # Generate a random todo 
    TODO_ID=$(shuf -i 1000-9999 -n 1)
    # Use Laravel's artisan tinker to create a contract using the model
    php artisan tinker --execute="App\Todo::create(['tasks' => '$TODO_ID']);"
done
EOF

# Step 5: Make the bash script executable
chmod +x /home/vagrant/create_todo.sh

# Step 6: Set up the cron job to run the script every minute
(crontab -l ; echo "* * * * * /home/vagrant/create_todo.sh >> /home/vagrant/contract_creation.log 2>&1") | crontab -

echo "Setup complete. todo will be created every minute."
