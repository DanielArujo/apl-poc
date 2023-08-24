package apiGateway

import (
	"encoding/json"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
)

type Response struct {
	Message    *string `json:"message"`
	StatusCode *string `json:"statusCode"`
}

type Error struct {
	Error *string `json:"error"`
}

func InternalServerError(err string) events.APIGatewayProxyResponse {
	fmt.Println(err)
	return events.APIGatewayProxyResponse{Body: "Internal server error", StatusCode: 500}
}

func ResponseSuccessfully(message interface{}, StatusCode int) events.APIGatewayProxyResponse {
	fmt.Println(message)

	responseFormat, _ := json.Marshal(message)
	return events.APIGatewayProxyResponse{Body: string(responseFormat), StatusCode: StatusCode}
}

func ResponseError(err string, StatusCode int) events.APIGatewayProxyResponse {
	fmt.Println(err)

	if StatusCode == 500 {
		messageErro := "Error: Internal server error"
		responseFormat, _ := json.Marshal(Error{Error: &messageErro})
		return events.APIGatewayProxyResponse{Body: string(responseFormat), StatusCode: StatusCode}
	}

	responseFormat, _ := json.Marshal(Error{Error: &err})
	return events.APIGatewayProxyResponse{Body: string(responseFormat), StatusCode: StatusCode}
}
