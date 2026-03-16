<#import "template.ftl" as layout>

<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username'); section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "subtitle">
        ${msg("resetPasswordSubtitle")}
    <#elseif section = "form">

        <form id="kc-reset-password-form" class="dens-form" action="${url.loginAction}" method="post">
            <div class="dens-field">
                <label class="dens-label" for="username">
                    <#if !realm.loginWithEmailAllowed>
                        ${msg("username")}
                    <#elseif !realm.registrationEmailAsUsername>
                        ${msg("usernameOrEmail")}
                    <#else>
                        ${msg("email")}
                    </#if>
                </label>

                <div class="dens-input-wrap <#if messagesPerField.existsError('username')>is-error</#if>">
                    <span class="dens-input-icon" aria-hidden="true">
                        <img src="${url.resourcesPath}/${properties.densEmailIcon!'img/icon-email.svg'}" alt="" />
                    </span>

                    <input
                        id="username"
                        name="username"
                        type="text"
                        class="dens-input"
                        value="${(auth.attemptedUsername!'')}"
                        autocomplete="username"
                        autofocus
                        aria-invalid="<#if messagesPerField.existsError('username')>true<#else>false</#if>"
                    />
                </div>

                <#if messagesPerField.existsError('username')>
                    <span class="dens-field-error">${kcSanitize(messagesPerField.get('username'))?no_esc}</span>
                </#if>
            </div>

            <div class="dens-actions">
                <button class="dens-submit" type="submit">
                    ${msg("doSubmit")}
                </button>
            </div>

            <div class="dens-register dens-register--back">
                <a class="dens-inline-link" href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a>
            </div>
        </form>

    </#if>
</@layout.registrationLayout>
