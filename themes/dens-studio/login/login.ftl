<#import "template.ftl" as layout>

<@layout.registrationLayout displayInfo=false displayMessage=!messagesPerField.existsError('username','password'); section>
    <#if section = "header">
        ${msg("loginTitle")}
    <#elseif section = "form">
        <form id="kc-form-login" class="dens-form" action="${url.loginAction}" method="post">
            <div class="dens-field">
                <label class="dens-label" for="username">${msg("email")}</label>
                <div class="dens-input-wrap <#if messagesPerField.existsError('username')>is-error</#if>">
                    <span class="dens-input-icon" aria-hidden="true">
                        <img src="${url.resourcesPath}/${properties.densEmailIcon!'img/icon-email.svg'}" alt="" />
                    </span>
                    <input id="username" name="username" type="text" class="dens-input" value="${(login.username!'')}" autocomplete="username" autofocus aria-invalid="<#if messagesPerField.existsError('username')>true<#else>false</#if>" />
                </div>
                <#if messagesPerField.existsError('username')>
                    <span class="dens-field-error">${kcSanitize(messagesPerField.get('username'))?no_esc}</span>
                </#if>
            </div>

            <div class="dens-field">
                <label class="dens-label" for="password">${msg("password")}</label>
                <div class="dens-input-wrap <#if messagesPerField.existsError('password')>is-error</#if>">
                    <span class="dens-input-icon" aria-hidden="true">
                        <img src="${url.resourcesPath}/${properties.densLockIcon!'img/icon-lock.svg'}" alt="" />
                    </span>
                    <input id="password" name="password" type="password" class="dens-input dens-input--password" autocomplete="current-password" aria-invalid="<#if messagesPerField.existsError('password')>true<#else>false</#if>" />
                    <button type="button" class="dens-password-toggle" data-password-toggle aria-label="Mostra o nascondi password" aria-controls="password" aria-pressed="false">
                        <span aria-hidden="true">👁</span>
                    </button>
                </div>
                <#if messagesPerField.existsError('password')>
                    <span class="dens-field-error">${kcSanitize(messagesPerField.get('password'))?no_esc}</span>
                </#if>
            </div>

            <div class="dens-actions">
                <button class="dens-submit" id="kc-login" name="login" type="submit">${msg("doLogIn")}</button>
            </div>

            <#if (properties.densShowDemoCredentials!'false') == 'true'>
                <div class="dens-demo">
                    <div class="dens-demo__title">${msg("demoCredentialsTitle")}</div>
                    <#if properties.densDemoEmail?? && properties.densDemoEmail?has_content>
                        <div class="dens-demo__row">${msg("email")}: ${properties.densDemoEmail}</div>
                    </#if>
                    <#if properties.densDemoPassword?? && properties.densDemoPassword?has_content>
                        <div class="dens-demo__row">${msg("password")}: ${properties.densDemoPassword}</div>
                    </#if>
                </div>
            </#if>
        </form>
    </#if>
</@layout.registrationLayout>
