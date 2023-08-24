package main

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/aws-playground/lambda/entity"
	dynamodb "github.com/aws-playground/pkg/dynamoDb"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(handler)
}

func handler(ctx context.Context, sqsEvent events.SQSEvent) error {

	dynamoDbSession, err := dynamodb.NewSessionDynamoDb()
	if err != nil {
		return err
	}

	for _, message := range sqsEvent.Records {
		fmt.Printf("Event request: %s\n", message.MessageId)

		var body entity.Client

		json.Unmarshal([]byte(message.Body), &body)

		dynamoDbSession.AddOrUpdate("user", &entity.Client{
			Id:        message.MessageId,
			Name:      body.Name,
			CPF:       body.CPF,
			CreatedBy: body.CreatedBy,
		})

	}

	return nil
}
