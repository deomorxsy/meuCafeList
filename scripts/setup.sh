#!/bin/bash

mvn_skeleton() {
mvn archetype:generate \
	-DgroupId=com.mycafelist.app \
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

# match second ocurrence of pattern, append SPRING_PLUGIN. cheatsheet below
# t = conditional branch;
# a = append text
# P = prints line from the pattern space until the first newline
#
sed -i "/</artifactId>/!b;:a;\$!N;s/</artifactId>/$SPRING_PLUGIN/2;ta;P;D" ./server/pom.xml

}
