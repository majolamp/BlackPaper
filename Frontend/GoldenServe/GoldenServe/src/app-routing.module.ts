import { NgModule } from "@angular/core";
import {Routes, RouterModule } from '@angular/router';

import { ShoppingCartComponent } from "./app/components/shopping-cart/shopping-cart.component";
import { LoginComponent } from "./app/components/login/login.component";
import { RegisterComponent } from "./app/components/register/register.component";
import { PageNotFoundComponent } from "./app/components/shared/page-not-found/page-not-found.component";

const routes: Routes = [
  {path: '',redirectTo: '/shop', pathMatch: 'full'},
  {path: 'login', component: LoginComponent },
  {path: 'register', component: RegisterComponent },
  {path: 'shop', component: ShoppingCartComponent },
  {path: '**', component: PageNotFoundComponent }
]
@NgModule({
  imports: [

    RouterModule.forRoot(routes)
  ],
  exports: [
    RouterModule
  ]
})
export class AppRoutingModule{

}
