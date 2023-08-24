package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"github.com/aws-playground/lambda/entity"
	"github.com/aws-playground/pkg/apiGateway"
	"github.com/aws-playground/pkg/sqsCli"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	ginadapter "github.com/awslabs/aws-lambda-go-api-proxy/gin"
	"github.com/gin-gonic/gin"
)

var ginLambda *ginadapter.GinLambda

// Handler is the main entry point for Lambda. Receives a proxy request and
// returns a proxy response
func Handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	path := req.Path

	fmt.Println("PATH : ", path)
	if ginLambda == nil {
		// stdout and stderr are sent to AWS CloudWatch Logs
		log.Printf("Gin cold start")
		r := gin.Default()
		r.POST("/costumer", createCostumer)

		ginLambda = ginadapter.New(r)
	}

	body, err := ginLambda.ProxyWithContext(ctx, req)

	if err != nil {
		return apiGateway.InternalServerError("Error to proxy with context:" + err.Error()), nil
	}

	sqsSession, err := sqsCli.NewSessionSqs()
	if err != nil {
		return apiGateway.InternalServerError("Error to create session sqs:" + err.Error()), nil
	}

	_, err = sqsSession.SendMessage("users", string(body.Body))
	if err != nil {
		return apiGateway.InternalServerError("Error to send sqs message:" + err.Error()), nil
	}

	return ginLambda.ProxyWithContext(ctx, req)
}

func main() {
	lambda.Start(Handler)
}

func createCostumer(c *gin.Context) {
	fmt.Println("CONTEXTT: ", c)
	var newCostumer entity.Client
	err := c.BindJSON(&newCostumer)

	if err != nil {
		return
	}

	c.JSON(http.StatusAccepted, newCostumer)
}
