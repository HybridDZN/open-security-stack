FROM wazuh/wazuh-manager:4.12.0

RUN /var/ossec/framework/python/bin/pip3 install --no-cache-dir \
    requests \
    thehive4py \
    urllib3

COPY wazuh-custom/wazuh-init.sh /usr/local/bin/wazuh-init.sh
COPY wazuh-custom/startup.sh /usr/local/bin/startup.sh
COPY wazuh_integrations/ /var/ossec/integrations/

RUN chmod +x /usr/local/bin/wazuh-init.sh && \
    chmod +x /usr/local/bin/startup.sh && \
    chmod +x /var/ossec/integrations/custom-w2thive && \
    chown -R root:wazuh /var/ossec/integrations/

ENTRYPOINT ["/usr/local/bin/startup.sh"]

