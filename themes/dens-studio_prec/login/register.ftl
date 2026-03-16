<#import "template.ftl" as layout>
<#import "user-profile-commons.ftl" as userProfileCommons>
<#import "register-commons.ftl" as registerCommons>

<@layout.registrationLayout displayMessage=messagesPerField.exists('global') displayRequiredFields=true; section>
    <#if section = "header">
        ${msg("registerTitle")}
    <#elseif section = "subtitle">
        ${msg("registerSubtitle")}
    <#elseif section = "form">

        <form id="kc-register-form" class="dens-form dens-form--register" action="${url.registrationAction}" method="post">
            <@userProfileCommons.userProfileFormFields; callback, attribute>
                <#if callback = "beforeField">
                    <div class="dens-kc-field">
                <#elseif callback = "afterField">
                    </div>

                    <#if passwordRequired?? && (attribute.name == 'username' || (attribute.name == 'email' && realm.registrationEmailAsUsername))>
                        <div class="dens-field">
                            <label class="dens-label" for="password">${msg("password")}</label>
                            <input
                                type="password"
                                id="password"
                                name="password"
                                class="pf-c-form-control form-control"
                                autocomplete="new-password"
                                aria-invalid="<#if messagesPerField.existsError('password')>true<#else>false</#if>"
                            />
                            <#if messagesPerField.existsError('password')>
                                <span class="dens-field-error">${kcSanitize(messagesPerField.get('password'))?no_esc}</span>
                            </#if>
                        </div>

                        <div class="dens-field">
                            <label class="dens-label" for="password-confirm">${msg("passwordConfirm")}</label>
                            <input
                                type="password"
                                id="password-confirm"
                                name="password-confirm"
                                class="pf-c-form-control form-control"
                                autocomplete="new-password"
                                aria-invalid="<#if messagesPerField.existsError('password-confirm')>true<#else>false</#if>"
                            />
                            <#if messagesPerField.existsError('password-confirm')>
                                <span class="dens-field-error">${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}</span>
                            </#if>
                        </div>
                    </#if>
                </#if>
            </@userProfileCommons.userProfileFormFields>

            <div class="dens-kc-field">
                <@registerCommons.termsAcceptance/>
            </div>

            <#if recaptchaRequired??>
                <div class="dens-kc-field">
                    <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}" data-action="${recaptchaAction}"></div>
                </div>
            </#if>

            <div class="dens-actions">
                <button class="dens-submit" id="kc-register" type="submit">
                    ${msg("doRegister")}
                </button>
            </div>

            <div class="dens-register dens-register--back">
                <a class="dens-inline-link" href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a>
            </div>
        </form>

    </#if>
</@layout.registrationLayout>
