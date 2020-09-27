import { LastPhoneValidated } from "../generated/PhoneValidator/PhoneValidator";
import { PhoneValidated } from "../generated/schema";

export function handleLastPhoneValidated(event: LastPhoneValidated): void {
  let id = event.params.requestId.toHex();
  let phone = new PhoneValidated(id);
  phone.timestamp = event.block.timestamp;
  // phone.timestamp = new BigInt(new Date().getMilliseconds());
  phone.phone = event.params.phone.toString();
  phone.valid = event.params.valid || true;
  phone.location = event.params.location.toString();
  phone.save();
}
