#!/bin/bash

# Navigate to Laravel application directory
cd /var/www/html

# Step 1: Create the Contract model with migration
php artisan make:model Contract -m

# Step 2: Edit the migration file to add the required fields
MIGRATION_FILE=$(ls -t database/migrations/*create_contracts_table.php | head -n 1)
sed -i "/Schema::create('contracts', function (Blueprint \$table) {/a \
    \$table->string('contact_id'); \
    \$table->string('name'); \
    \$table->timestamps();" $MIGRATION_FILE

# Step 3: Run the migration to create the table in the database
php artisan migrate

# Step 4: Create the bash script to generate contracts
cat << 'EOF' > /home/vagrant/create_contracts.sh
#!/bin/bash

# Navigate to Laravel application directory
cd /var/www/html

# Loop to create 10 contracts
for i in {1..10}
do
    # Generate a random contact ID and name
    CONTACT_ID=$(shuf -i 1000-9999 -n 1)
    NAME="Contact_$CONTACT_ID"
    CREATION_DATE=$(date '+%Y-%m-%d %H:%M:%S')

    # Use Laravel's artisan tinker to create a contract using the model
    php artisan tinker --execute="App\Models\Contract::create(['contact_id' => '$CONTACT_ID', 'name' => '$NAME', 'updated_at' => '$CREATION_DATE']);"
done
EOF

# Step 5: Make the bash script executable
chmod +x /home/vagrant/create_contracts.sh

# Step 6: Set up the cron job to run the script every minute
(crontab -l ; echo "* * * * * /home/vagrant/create_contracts.sh >> /home/vagrant/contract_creation.log 2>&1") | crontab -

echo "Setup complete. Contracts will be created every minute."
