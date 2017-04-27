require 'aws-sdk'

client = Aws::EC2::Client.new(
    access_key_id: 'ACCESS_KEY_ID',
    secret_access_key: 'SECRET_ACCESS_KEY',
    region: 'us-west-2'
)

resp = client.create_tags({
  dry_run: false,
  resources: ["i-5b6d5186"], # required
  tags: [ # required
    {
      key: "Name",
      value: "Copy of Zuma - mgmt server #1",
    },
  ],
})

puts resp