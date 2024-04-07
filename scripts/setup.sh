#!/bin/bash

mvn_skeleton() {
mvn -q archetype:generate \
	-DgroupId=com.meucafelist.app \
	-DartifactId=server \
	-DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.0 \
	-DinteractiveMode=false
}

spring_setup() {

SPRING_DEPENDENCIES=$(cat << 'EOF'
    <dependency> \
		<groupId>org.springframework.boot</groupId> \
		<artifactId>spring-boot-starter</artifactId> \
        <version>3.1.5</version> \
	</dependency> \
	<dependency> \
		<groupId>org.springframework.boot</groupId> \
		<artifactId>spring-boot-starter-test</artifactId> \
		<scope>test</scope> \
	</dependency>
EOF
)

SPRING_PARENT=$(cat <<'EOF'
  <parent>  \
    <groupId>org.springframework.boot</groupId> \
	<artifactId>spring-boot-starter-parent</artifactId> \
	<version>3.2.4</version> \
	<relativePath/> <!-- lookup parent from repository --> \
  </parent>
EOF
)

SPRING_PLUGIN=$(cat <<'EOF'
    <build> \
        <plugins> \
                <plugin> \
                    <groupId>org.springframework.boot</groupId> \
                    <artifactId>spring-boot-maven-plugin</artifactId> \
            </plugin> \
        </plugins> \
    </build> \
    <properties> \
     <maven.compiler.source>1.8</maven.compiler.source> \
     <maven.compiler.target>1.8</maven.compiler.target> \
     <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding> \
     <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding> \
    </properties>
EOF
)

# first set the range of patterns,
# group the commands with {}
# append multi-line indented string after pattern
sed -i "/<project/,/<\/project>/ {
/<\/dependencies>/a\
$SPRING_PLUGIN
}" ./server/pom.xml

sed -i "/<project/,/<\/project>/ {
/<\/modelVersion>/a\
$SPRING_PARENT
}" ./server/pom.xml

sed -i "/<project/,/<\/project>/ {
/<dependencies>/a\
$SPRING_DEPENDENCIES
}" ./server/pom.xml

}
