package sqsCli

import (
	"errors"
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
)

type sqsCli struct {
	Session *session.Session
	SqsUrl  string
}

func NewSessionSqs() (*sqsCli, error) {
	sqsUrl := fmt.Sprintf("http://%s:4566", os.Getenv("LOCALSTACK_HOSTNAME"))

	session, err := session.NewSession(&aws.Config{
		Endpoint: aws.String(sqsUrl),
		Region:   aws.String("sa-east-1"),
	})

	if err != nil {
		return nil, errors.New(err.Error())
	}

	s := &sqsCli{Session: session, SqsUrl: sqsUrl}
	return s, nil
}

func (s *sqsCli) SendMessage(topic string, messageBody string) (*sqs.SendMessageOutput, error) {
	svc := sqs.New(s.Session)

	input := &sqs.SendMessageInput{
		QueueUrl:    aws.String(fmt.Sprintf("%s/000000000000/%s", s.SqsUrl, topic)),
		MessageBody: aws.String(messageBody),
	}

	r, err := svc.SendMessage(input)

	if err != nil {
		return nil, err
	}

	return r, nil
}
