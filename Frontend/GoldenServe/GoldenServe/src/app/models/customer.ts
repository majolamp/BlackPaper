export class Customer {
customerId: number;
firstName: string;
lastName: string;
email:string;
password: string;

constructor(customerId = 0,firstName = '', lastName = '', email = '', password = ''){
  this.customerId = customerId;
  this.firstName = firstName;
  this.lastName = lastName;
  this.email = email;
  this.password = password;
}

}

