<#import "template.ftl" as layout>

<@layout.registrationLayout displayMessage=messagesPerField.exists('global') displayRequiredFields=true; section>
    <#if section = "header">
        ${msg("registerTitle")}
    <#elseif section = "subtitle">
        ${msg("registerSubtitle")}
    <#elseif section = "form">
        <form id="kc-register-form" class="dens-form dens-form--register" action="${url.registrationAction}" method="post" novalidate="novalidate">
            <#if !realm.registrationEmailAsUsername>
                <div class="dens-field dens-field--full">
                    <label class="dens-label" for="username">${msg("username")}</label>
                    <input
                        type="text"
                        id="username"
                        name="username"
                        class="dens-plain-input"
                        value="${(register.formData.username!'')}"
                        autocomplete="username"
                        aria-invalid="<#if messagesPerField.existsError('username')>true<#else>false</#if>"
                    />
                    <#if messagesPerField.existsError('username')>
                        <span class="dens-field-error">${kcSanitize(messagesPerField.get('username'))?no_esc}</span>
                    </#if>
                </div>
            </#if>

            <div class="dens-field dens-field--full">
                <label class="dens-label" for="email">${msg("email")}</label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    class="dens-plain-input"
                    value="${(register.formData.email!'')}"
                    autocomplete="email"
                    aria-invalid="<#if messagesPerField.existsError('email')>true<#else>false</#if>"
                />
                <#if messagesPerField.existsError('email')>
                    <span class="dens-field-error">${kcSanitize(messagesPerField.get('email'))?no_esc}</span>
                </#if>
            </div>

            <div class="dens-field-grid dens-field-grid--two">
                <div class="dens-field">
                    <label class="dens-label" for="firstName">${msg("firstName")}</label>
                    <input
                        type="text"
                        id="firstName"
                        name="firstName"
                        class="dens-plain-input"
                        value="${(register.formData.firstName!'')}"
                        autocomplete="given-name"
                        aria-invalid="<#if messagesPerField.existsError('firstName')>true<#else>false</#if>"
                    />
                    <#if messagesPerField.existsError('firstName')>
                        <span class="dens-field-error">${kcSanitize(messagesPerField.get('firstName'))?no_esc}</span>
                    </#if>
                </div>
                <div class="dens-field">
                    <label class="dens-label" for="lastName">${msg("lastName")}</label>
                    <input
                        type="text"
                        id="lastName"
                        name="lastName"
                        class="dens-plain-input"
                        value="${(register.formData.lastName!'')}"
                        autocomplete="family-name"
                        aria-invalid="<#if messagesPerField.existsError('lastName')>true<#else>false</#if>"
                    />
                    <#if messagesPerField.existsError('lastName')>
                        <span class="dens-field-error">${kcSanitize(messagesPerField.get('lastName'))?no_esc}</span>
                    </#if>
                </div>
            </div>

            <div class="dens-field-grid dens-field-grid--two">
                <div class="dens-field">
                    <label class="dens-label" for="password">${msg("password")}</label>
                    <div class="dens-input-wrap <#if messagesPerField.existsError('password')>is-error</#if>">
                        <span class="dens-input-icon" aria-hidden="true">
                            <img src="${url.resourcesPath}/${properties.densLockIcon!'img/icon-lock.svg'}" alt="" />
                        </span>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            class="dens-input dens-input--password"
                            autocomplete="new-password"
                            aria-invalid="<#if messagesPerField.existsError('password')>true<#else>false</#if>"
                        />
                        <button type="button" class="dens-password-toggle" data-password-toggle data-password-target="password" aria-label="Mostra o nascondi password" aria-controls="password" aria-pressed="false">
                            <span aria-hidden="true">👁</span>
                        </button>
                    </div>
                    <#if messagesPerField.existsError('password')>
                        <span class="dens-field-error">${kcSanitize(messagesPerField.get('password'))?no_esc}</span>
                    </#if>
                </div>
                <div class="dens-field">
                    <label class="dens-label" for="password-confirm">${msg("passwordConfirm")}</label>
                    <div class="dens-input-wrap <#if messagesPerField.existsError('password-confirm')>is-error</#if>">
                        <span class="dens-input-icon" aria-hidden="true">
                            <img src="${url.resourcesPath}/${properties.densLockIcon!'img/icon-lock.svg'}" alt="" />
                        </span>
                        <input
                            type="password"
                            id="password-confirm"
                            name="password-confirm"
                            class="dens-input dens-input--password"
                            autocomplete="new-password"
                            aria-invalid="<#if messagesPerField.existsError('password-confirm')>true<#else>false</#if>"
                        />
                        <button type="button" class="dens-password-toggle" data-password-toggle data-password-target="password-confirm" aria-label="Mostra o nascondi password" aria-controls="password-confirm" aria-pressed="false">
                            <span aria-hidden="true">👁</span>
                        </button>
                    </div>
                    <#if messagesPerField.existsError('password-confirm')>
                        <span class="dens-field-error">${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}</span>
                    </#if>
                </div>
            </div>

            <#if recaptchaRequired??>
                <div class="dens-kc-field">
                    <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}" data-action="${recaptchaAction}"></div>
                </div>
            </#if>

            <div class="dens-actions">
                <button class="dens-submit" id="kc-register" type="submit">${msg("doRegister")}</button>
            </div>

            <div class="dens-register dens-register--back">
                <a class="dens-inline-link" href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>
