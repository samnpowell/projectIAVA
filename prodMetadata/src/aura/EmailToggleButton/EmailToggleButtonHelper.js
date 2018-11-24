/**
 * Created by tarren.anderson on 8/23/17.
 */
({
    configureTitle : function(component, isDisabled){
        var thisTitle = 'Emails have been enabled';
        if(isDisabled){
            thisTitle = 'Emails have been disabled';
        }
        component.set('v.titleMessage', thisTitle);
        component.set('v.showStatus', true);
        setTimeout(function(){component.set('v.showStatus', false)}, 5000);
    },
    calculateCSS : function(component, queryResult){
        if(queryResult.emailValue){
            component.set('v.button_classes', component.get('v.class_when_off'));
        } else{
            component.set('v.button_classes', component.get('v.class_when_on'));
        }
    }
})