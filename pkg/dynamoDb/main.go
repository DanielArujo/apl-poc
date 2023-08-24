package dynamodb

import (
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
)

type dynamodbCli struct {
	Session   *session.Session
	dynamoUrl string
}

func NewSessionDynamoDb() (*dynamodbCli, error) {
	dynamoUrl := fmt.Sprintf("http://%s:4566", os.Getenv("LOCALSTACK_HOSTNAME"))

	session, err := session.NewSession(&aws.Config{
		Endpoint: aws.String(dynamoUrl),
		Region:   aws.String("sa-east-1"),
	})

	if err != nil {
		fmt.Println("Error: unable to start a session", err)
	}

	d := &dynamodbCli{Session: session, dynamoUrl: dynamoUrl}
	return d, nil
}

func (d *dynamodbCli) AddOrUpdate(tableName string, data interface{}) (*dynamodb.PutItemOutput, error) {
	svc := dynamodb.New(d.Session)

	tuple, err := dynamodbattribute.MarshalMap(data)
	if err != nil {
		fmt.Println("Error converting item to DynamoDB format:", err)
		return nil, err
	}

	input := &dynamodb.PutItemInput{
		Item:      tuple,
		TableName: aws.String(tableName),
	}

	output, err := svc.PutItem(input)

	if err != nil {
		fmt.Println("error inserting item into DynamoDB:", err)
		return nil, err
	}

	return output, nil
}
