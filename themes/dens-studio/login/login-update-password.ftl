<#import "template.ftl" as layout>

<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm'); section>
    <#if section = "header">
        ${msg("updatePasswordTitle")}
    <#elseif section = "subtitle">
        ${msg("updatePasswordSubtitle")}
    <#elseif section = "form">

        <form id="kc-passwd-update-form" class="dens-form" action="${url.loginAction}" method="post">
            <div class="dens-field">
                <label class="dens-label" for="password-new">${msg("passwordNew")}</label>
                <input
                    type="password"
                    id="password-new"
                    name="password-new"
                    class="pf-c-form-control form-control"
                    autocomplete="new-password"
                    aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true<#else>false</#if>"
                    autofocus
                />
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

                <#if messagesPerField.existsError('password','password-confirm')>
                    <span class="dens-field-error">${kcSanitize(messagesPerField.getFirstError('password','password-confirm'))?no_esc}</span>
                </#if>
            </div>

            <div class="dens-actions">
                <button class="dens-submit" type="submit">${msg("doSubmit")}</button>
            </div>
        </form>

    </#if>
</@layout.registrationLayout>
