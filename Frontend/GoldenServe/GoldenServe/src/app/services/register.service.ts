import { Injectable } from '@angular/core';
import { Customer } from '../models/customer';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { customerUrl } from 'src/app/config/api';

@Injectable({
  providedIn: 'root'
})
export class RegisterService {

  constructor(private http: HttpClient) {}

    addCustomer(customer:Customer): Observable<any> {
      const headers = {'content-type': 'application/json'}
      const body = JSON.stringify(customer)
      console.log(body)
      return this.http.post(customerUrl, body,{'headers':headers})
    }
}
