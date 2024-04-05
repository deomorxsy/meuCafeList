#!/bin/bash

mvn_skeleton() {
mvn archetype:generate \
	-DgroupId=com.meucafelist.app \
	-DartifactId=server \
	-DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.0 \
	-DinteractiveMode=false
}

spring_setup() {

SPRING_PLUGIN=$(cat <<'EOF'
<build> \
    <plugins> \
        <plugin> \
            <groupId>org.springframework.boot</groupId> \
            <artifactId>spring-boot-maven-plugin</artifactId> \
        </plugin> \
    </plugins> \
</build>
EOF
)

# todo: fix it to the second ocurrence
sed -i '/</artifactId>/a '"$SPRING_PLUGIN" ./pom.xml

}
