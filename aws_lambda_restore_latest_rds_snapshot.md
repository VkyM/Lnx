## Find latest RDS instatnce and restore it

```python
import boto3

def lambda_handler(event, context):
    # Initialize the RDS client
    rds_client = boto3.client('rds')

    # List RDS instances
    response = rds_client.describe_db_snapshots()
    latest_snapshot = None
    latest_snapshot_time = None

# Loop through the snapshots and find the latest one
    for snapshot in response['DBSnapshots']:
        snapshot_time = snapshot['SnapshotCreateTime']
    
    # Compare the creation time of the current snapshot with the latest found
        if latest_snapshot_time is None or snapshot_time > latest_snapshot_time:
            latest_snapshot = snapshot
            latest_snapshot_time = snapshot_time

# Print information about the latest snapshot
    if latest_snapshot:
        print("Latest Snapshot Identifier:", latest_snapshot['DBSnapshotIdentifier'])
        print("DB Instance Identifier:", latest_snapshot['DBInstanceIdentifier'])
        print("Status:", latest_snapshot['Status'])
        print("Snapshot Creation Time:", latest_snapshot['SnapshotCreateTime'])
        # restore
        
        restore_response = rds_client.restore_db_instance_from_db_snapshot(
        DBInstanceIdentifier='test1',
        DBSnapshotIdentifier=latest_snapshot['DBSnapshotIdentifier'],
        DBInstanceClass='db.t2.medium',  # Specify the desired instance class
        StorageType='gp2',  # Specify the storage type
        )
    
    # You can check the response for the status of the restoration process
        print("Restoration process started. Check the AWS Console for status.")
        
    else:
        print("No RDS snapshots found.")

    return {
        "statusCode": 200,
        "body": "RDS instances listed successfully."
    }
```
