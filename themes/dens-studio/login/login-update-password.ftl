<#import "template.ftl" as layout>

<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm') displayRequiredFields=true; section>
    <#if section = "header">
        ${msg("updatePasswordTitle")}
    <#elseif section = "subtitle">
        ${msg("updatePasswordSubtitle")}
    <#elseif section = "form">
        <form id="kc-passwd-update-form" class="dens-form" action="${url.loginAction}" method="post">
            <div class="dens-field">
                <label class="dens-label" for="password-new">${msg("passwordNew")}</label>
                <div class="dens-input-wrap <#if messagesPerField.existsError('password','password-confirm')>is-error</#if>">
                    <span class="dens-input-icon" aria-hidden="true">
                        <img src="${url.resourcesPath}/${properties.densLockIcon!'img/icon-lock.svg'}" alt="" />
                    </span>
                    <input
                        type="password"
                        id="password-new"
                        name="password-new"
                        class="dens-input dens-input--password"
                        autocomplete="new-password"
                        autofocus
                        aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true<#else>false</#if>"
                    />
                    <button
                        type="button"
                        class="dens-password-toggle"
                        data-password-toggle
                        data-password-target="password-new"
                        aria-label="${msg('togglePasswordLabel')}"
                        aria-controls="password-new"
                        aria-pressed="false"
                    >
                        <span class="dens-eye" aria-hidden="true"></span>
                    </button>
                </div>
            </div>

            <div class="dens-field">
                <label class="dens-label" for="password-confirm">${msg("passwordConfirm")}</label>
                <div class="dens-input-wrap <#if messagesPerField.existsError('password','password-confirm')>is-error</#if>">
                    <span class="dens-input-icon" aria-hidden="true">
                        <img src="${url.resourcesPath}/${properties.densLockIcon!'img/icon-lock.svg'}" alt="" />
                    </span>
                    <input
                        type="password"
                        id="password-confirm"
                        name="password-confirm"
                        class="dens-input dens-input--password"
                        autocomplete="new-password"
                        aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true<#else>false</#if>"
                    />
                    <button
                        type="button"
                        class="dens-password-toggle"
                        data-password-toggle
                        data-password-target="password-confirm"
                        aria-label="${msg('togglePasswordLabel')}"
                        aria-controls="password-confirm"
                        aria-pressed="false"
                    >
                        <span class="dens-eye" aria-hidden="true"></span>
                    </button>
                </div>
                <#if messagesPerField.existsError('password','password-confirm')>
                    <span class="dens-field-error">${kcSanitize(messagesPerField.getFirstError('password','password-confirm'))?no_esc}</span>
                </#if>
            </div>

            <div class="dens-actions">
                <button class="dens-submit" id="kc-passwd-update" type="submit">${msg("doSubmit")}</button>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>
