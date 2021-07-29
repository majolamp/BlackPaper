import { Component, Input, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators, FormControl } from '@angular/forms';
import {RegisterService} from 'src/app/services/register.service';
import { MessengerService } from 'src/app/services/messenger.service';
import{Customer} from 'src/app/models/customer';

function passwordsMatchValidator(form: { get: (arg0: string) => any; }) {
  const password = form.get('password')
  const confirmPassword = form.get('confirmPassword')

  if(password.value !== confirmPassword.value) {
    confirmPassword.setErrors({ passwordsMatch: true })
  } else {
    confirmPassword.setErrors(null)
  }

  return null
}


function symbolValidator(control: { hasError: (arg0: string) => any; value: string | string[]; }) {
  if(control.hasError('required')) return null;
  if(control.hasError('minlength')) return null;

  if(control.value.indexOf('@') > -1) {
    return null
  } else {
    return { symbol: true }
  }
}

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {

  registerForm: FormGroup;
  @Input() customerDetail: Customer;

  constructor(
    private builder: FormBuilder,
    private msg: MessengerService,
    private registerService: RegisterService
    ) { }

  ngOnInit() {
    this.buildForm()
  }

  buildForm() {
    this.registerForm = this.builder.group({
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, symbolValidator, Validators.minLength(4)]],
      confirmPassword: ''
    }, {
      validators: passwordsMatchValidator
    })
  }

  register() {
    console.log(this.registerForm.value)
  }

  handleAddToCustomer(){
    this.registerService.addCustomer(this.customerDetail).subscribe(() =>{
      this.msg.sendMsg(this.customerDetail)
    })

  }

}
