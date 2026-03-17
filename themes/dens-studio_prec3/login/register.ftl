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
                    <div class="dens-kc-field dens-kc-field--attribute" <#if attribute.name??>data-attribute-name="${attribute.name}"</#if>>
                <#elseif callback = "afterField">
                    </div>

                    <#if passwordRequired?? && (attribute.name == 'username' || (attribute.name == 'email' && realm.registrationEmailAsUsername))>
                        <div class="dens-kc-field dens-kc-field--password" data-attribute-name="password">
                            <label class="dens-label" for="password">${msg("password")}</label>
                            <div class="dens-input-wrap <#if messagesPerField.existsError('password')>is-error</#if>">
                                <input
                                    type="password"
                                    id="password"
                                    name="password"
                                    class="dens-plain-input"
                                    autocomplete="new-password"
                                    aria-invalid="<#if messagesPerField.existsError('password')>true<#else>false</#if>"
                                />
                                <button
                                    type="button"
                                    class="dens-password-toggle"
                                    data-password-toggle
                                    data-password-target="password"
                                    aria-label="${msg('togglePasswordLabel')}"
                                    aria-controls="password"
                                    aria-pressed="false"
                                >
                                    <span class="dens-eye" aria-hidden="true"></span>
                                </button>
                            </div>
                            <#if messagesPerField.existsError('password')>
                                <span class="dens-field-error">${kcSanitize(messagesPerField.get('password'))?no_esc}</span>
                            </#if>
                        </div>

                        <div class="dens-kc-field dens-kc-field--password" data-attribute-name="password-confirm">
                            <label class="dens-label" for="password-confirm">${msg("passwordConfirm")}</label>
                            <div class="dens-input-wrap <#if messagesPerField.existsError('password-confirm')>is-error</#if>">
                                <input
                                    type="password"
                                    id="password-confirm"
                                    name="password-confirm"
                                    class="dens-plain-input"
                                    autocomplete="new-password"
                                    aria-invalid="<#if messagesPerField.existsError('password-confirm')>true<#else>false</#if>"
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
                            <#if messagesPerField.existsError('password-confirm')>
                                <span class="dens-field-error">${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}</span>
                            </#if>
                        </div>
                    </#if>
                </#if>
            </@userProfileCommons.userProfileFormFields>

            <div class="dens-kc-field dens-kc-field--terms">
                <@registerCommons.termsAcceptance/>
            </div>

            <#if recaptchaRequired??>
                <div class="dens-kc-field dens-kc-field--recaptcha">
                    <div class="g-recaptcha" data-sitekey="${recaptchaSiteKey}" data-action="${recaptchaAction}"></div>
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
