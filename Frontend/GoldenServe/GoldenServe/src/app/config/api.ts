import { environment } from "src/environments/environment";
export const baseUrl = environment.production ? 'https://api.goldenserve.com' : 'http://localhost:50857/api'
export const productUrl = baseUrl + '/product'
export const cartUrl = baseUrl + '/cart'
export const customerUrl = baseUrl + '/customer'
