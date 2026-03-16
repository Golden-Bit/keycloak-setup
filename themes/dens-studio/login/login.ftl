<#import "template.ftl" as layout>

<@layout.registrationLayout
    displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??
    displayMessage=!messagesPerField.existsError('username','password');
    section>

    <#if section = "header">
        ${msg("loginTitle")}
    <#elseif section = "subtitle">
        ${msg("loginSubtitle")}
    <#elseif section = "form">

        <form id="kc-form-login" class="dens-form" action="${url.loginAction}" method="post">
            <#if !usernameHidden??>
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

                    <div class="dens-input-wrap <#if messagesPerField.existsError('username','password')>is-error</#if>">
                        <span class="dens-input-icon" aria-hidden="true">
                            <img src="${url.resourcesPath}/${properties.densEmailIcon!'img/icon-email.svg'}" alt="" />
                        </span>

                        <input
                            id="username"
                            name="username"
                            type="text"
                            class="dens-input"
                            value="${(login.username!'')}"
                            autocomplete="username"
                            autofocus
                            aria-invalid="<#if messagesPerField.existsError('username','password')>true<#else>false</#if>"
                        />
                    </div>

                    <#if messagesPerField.existsError('username','password')>
                        <span class="dens-field-error">
                            ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                        </span>
                    </#if>
                </div>
            <#else>
                <input type="hidden" id="username" name="username" value="${(login.username!'')}" />
            </#if>

            <div class="dens-field">
                <label class="dens-label" for="password">${msg("password")}</label>

                <div class="dens-input-wrap <#if messagesPerField.existsError('username','password')>is-error</#if>">
                    <span class="dens-input-icon" aria-hidden="true">
                        <img src="${url.resourcesPath}/${properties.densLockIcon!'img/icon-lock.svg'}" alt="" />
                    </span>

                    <input
                        id="password"
                        name="password"
                        type="password"
                        class="dens-input dens-input--password"
                        autocomplete="current-password"
                        aria-invalid="<#if messagesPerField.existsError('username','password')>true<#else>false</#if>"
                    />

                    <button
                        type="button"
                        class="dens-password-toggle"
                        data-password-toggle
                        aria-label="Mostra o nascondi password"
                        aria-controls="password"
                        aria-pressed="false"
                    >
                        <span aria-hidden="true">👁</span>
                    </button>
                </div>

                <#if usernameHidden?? && messagesPerField.existsError('username','password')>
                    <span class="dens-field-error">
                        ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                    </span>
                </#if>
            </div>

            <#if realm.resetPasswordAllowed>
                <div class="dens-form-links">
                    <a class="dens-inline-link" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
                </div>
            </#if>

            <input type="hidden" id="id-hidden-input" name="credentialId"
                <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>

            <div class="dens-actions">
                <button class="dens-submit" id="kc-login" name="login" type="submit">${msg("doLogIn")}</button>
            </div>

            <#if realm.rememberMe && !usernameHidden??>
                <div class="dens-remember-wrap">
                    <label class="dens-checkbox">
                        <input type="checkbox" id="rememberMe" name="rememberMe" <#if login.rememberMe??>checked</#if> />
                        <span>${msg("rememberMe")}</span>
                    </label>
                </div>
            </#if>
        </form>

    <#elseif section = "info">
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div class="dens-register">
                <span>${msg("noAccount")} <a class="dens-inline-link" href="${url.registrationUrl}">${msg("doRegister")}</a></span>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>
