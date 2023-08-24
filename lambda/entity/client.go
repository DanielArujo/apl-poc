package entity

type Client struct {
	Id        string `json:"id"`
	Name      string `json:"name"`
	CPF       string `json:"cpf"`
	CreatedBy string `json:"createdBy"`
}
