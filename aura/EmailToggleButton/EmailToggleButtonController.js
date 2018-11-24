/**
 * Created by tarren.anderson on 8/23/17.
 */
{
    doInit : function(component, event, helper){
        var action = component.get("c.getEmailState");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var thisResult = response.getReturnValue();
                component.set('v.emailIsDisabled', thisResult.emailValue);
                //helper.configureTitle(component, thisResult.emailValue);
                //helper.calculateCSS(component, thisResult);
            }
        });
        $A.enqueueAction(action);
    },
    toggleEmailJS : function(component, event, helper){
        var action = component.get("c.toggleEmail");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var thisResult = response.getReturnValue();
                component.set('v.emailIsDisabled', thisResult.emailValue);
                helper.configureTitle(component, thisResult.emailValue);
                //helper.calculateCSS(component, thisResult);
            }
        });
        $A.enqueueAction(action);
    }
}