import React from 'react';
import NoPayType from './NoPayType';
import CreditCardPayType from './CreditCardPayType';
import CheckPayType from './CheckPayType';
import PurchaseOrderPayType from './PurchaseOrderPayType';

export default class PayTypeSelector extends React.Component {
  constructor(props) {
    super(props);
    this.state= {
      selectedPayType: null
    };
    this.onPayTypeSelected = this.onPayTypeSelected.bind(this);
  };

  onPayTypeSelected(e) {
    console.log(e.target.value);
    this.setState({
      selectedPayType: e.target.value
    })
  };

  render() {
    let PayTypeCustomComponent = NoPayType;
    if (this.state.selectedPayType == "Credit card") {
      PayTypeCustomComponent = CreditCardPayType;
    }else if(this.state.selectedPayType == "Check") {
      PayTypeCustomComponent = CheckPayType;
    }else if(this.state.selectedPayType == "Purchase order") {
      PayTypeCustomComponent = PurchaseOrderPayType;
    }

    return (
        <div>
          <div className="field">
            <label htmlFor="order_pay_type">{I18n.t("orders.form.pay_type")}</label>
            <select name="order[pay_type]" id="pay_type" onChange={this.onPayTypeSelected}>
              <option value="">{I18n.t("orders.form.pay_prompt_html")}</option>
              <option value="Check">{I18n.t("orders.form.pay_types.check")}</option>
              <option value="Credit card">{I18n.t("orders.form.pay_types.credit_card")}</option>
              <option value="Purchase order">{I18n.t("orders.form.pay_types.purchase_order")}</option>
            </select>
          </div>
          <PayTypeCustomComponent/>
        </div>
    );
  }
}