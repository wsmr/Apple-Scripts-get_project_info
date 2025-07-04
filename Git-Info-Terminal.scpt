tell application "Finder"
    set selectedItems to selection
    
    -- Check if anything is selected
    if (count of selectedItems) = 0 then
        display dialog "Please select a folder first." buttons {"OK"} default button "OK"
        return
    end if
    
    -- Get the first selected item
    set selectedItem to item 1 of selectedItems as alias
    set folderPath to quoted form of POSIX path of selectedItem
    
end tell

tell application "Terminal"
    activate
    if (count of windows) > 0 then
        -- Open in new tab if Terminal is already open
        tell application "System Events" to keystroke "t" using command down
        delay 0.5
        do script "cd " & folderPath & " && bash -c '
echo \"=== PROJECT INFORMATION ===\"
echo \"\"

# Git Information
if [ -d \".git\" ]; then
    echo \"📁 GIT REPOSITORY INFO:\"
    echo \"Branch: $(git branch --show-current 2>/dev/null || echo \"No branch\")\"
    echo \"Repo: $(git remote get-url origin 2>/dev/null || echo \"No remote origin\")\"
    echo \"Last Commit: $(git log -1 --pretty=format:\"%h - %s (%an, %ar)\" 2>/dev/null || echo \"No commits\")\"
    echo \"Commit Date: $(git log -1 --pretty=format:\"%ci\" 2>/dev/null || echo \"N/A\")\"
    echo \"\"
else
    echo \"❌ No git repository found\"
    echo \"\"
fi

# Laravel Project Detection
if [ -f \"artisan\" ] && [ -f \"composer.json\" ]; then
    echo \"🚀 LARAVEL PROJECT DETECTED:\"
    echo \"PHP Version: $(php -v 2>/dev/null | head -n 1 | cut -d \" \" -f 2 || echo \"Not installed\")\"
    echo \"Laravel Version: $(grep \\\"laravel/framework\\\" composer.json | sed \"s/.*\\\"\\\\^\\\\([0-9]*\\\\.[0-9]*\\\\).*/\\\\1/\" || echo \"Unknown\")\"
    echo \"Composer Version: $(composer --version 2>/dev/null | cut -d \" \" -f 3 || echo \"Not installed\")\"
    echo \"\"
    echo \"📦 Laravel Commands:\"
    echo \"  Start: php artisan serve\"
    echo \"  Install: composer install\"
    echo \"  Migration: php artisan migrate\"
    echo \"\"
fi

# Ionic Angular Project Detection
if [ -f \"ionic.config.json\" ] && [ -f \"package.json\" ]; then
    echo \"📱 IONIC ANGULAR PROJECT DETECTED:\"
    echo \"Node Version: $(node -v 2>/dev/null || echo \"Not installed\")\"
    echo \"NPM Version: $(npm -v 2>/dev/null || echo \"Not installed\")\"
    echo \"Ionic Version: $(ionic -v 2>/dev/null || echo \"Not installed globally\")\"
    echo \"Angular Version: $(grep \\\"@angular/core\\\" package.json | sed \"s/.*\\\"\\\\^\\\\([0-9]*\\\\.[0-9]*\\\\).*/\\\\1/\" || echo \"Unknown\")\"
    echo \"\"
    echo \"📦 Ionic Commands:\"
    echo \"  Start: ionic serve\"
    echo \"  Install: npm install\"
    echo \"  Build: ionic build\"
    echo \"\"
fi

# React Project Detection
if [ -f \"package.json\" ] && ! [ -f \"ionic.config.json\" ]; then
    if grep -q \\\"react\\\" package.json; then
        echo \"⚛️  REACT PROJECT DETECTED:\"
        echo \"Node Version: $(node -v 2>/dev/null || echo \"Not installed\")\"
        echo \"NPM Version: $(npm -v 2>/dev/null || echo \"Not installed\")\"
        echo \"React Version: $(grep \\\"react\\\" package.json | sed \"s/.*\\\"\\\\^\\\\([0-9]*\\\\.[0-9]*\\\\).*/\\\\1/\" || echo \"Unknown\")\"
        echo \"\"
        echo \"📦 React Commands:\"
        echo \"  Start: npm start\"
        echo \"  Install: npm install\"
        echo \"  Build: npm run build\"
        echo \"\"
    fi
fi

# Vue Project Detection
if [ -f \"package.json\" ] && ! [ -f \"ionic.config.json\" ]; then
    if grep -q \\\"vue\\\" package.json; then
        echo \"🟢 VUE PROJECT DETECTED:\"
        echo \"Node Version: $(node -v 2>/dev/null || echo \"Not installed\")\"
        echo \"NPM Version: $(npm -v 2>/dev/null || echo \"Not installed\")\"
        echo \"Vue Version: $(grep \\\"vue\\\" package.json | sed \"s/.*\\\"\\\\^\\\\([0-9]*\\\\.[0-9]*\\\\).*/\\\\1/\" || echo \"Unknown\")\"
        echo \"\"
        echo \"📦 Vue Commands:\"
        echo \"  Start: npm run serve\"
        echo \"  Install: npm install\"
        echo \"  Build: npm run build\"
        echo \"\"
    fi
fi

# Java Spring Boot Project Detection
if [ -f \"pom.xml\" ] || [ -f \"build.gradle\" ] || [ -f \"build.gradle.kts\" ]; then
    echo \"☕ JAVA PROJECT DETECTED:\"
    echo \"Java Version: $(java -version 2>&1 | head -n 1 | cut -d \\\"\\\" -f 2 || echo \"Not installed\")\"
    
    if [ -f \"pom.xml\" ]; then
        echo \"Build Tool: Maven\"
        if grep -q \"spring-boot\" pom.xml; then
            echo \"Framework: Spring Boot detected\"
            SPRING_VERSION=$(grep -A 1 \"spring-boot-starter-parent\" pom.xml | grep \"version\" | sed \"s/.*<version>\\\\([^<]*\\\\)<\\/version>.*/\\\\1/\" | head -n 1)
            if [ ! -z \"$SPRING_VERSION\" ]; then
                echo \"Spring Boot Version: $SPRING_VERSION\"
            fi
        fi
        echo \"Maven Version: $(mvn -v 2>/dev/null | head -n 1 | cut -d \" \" -f 3 || echo \"Not installed\")\"
        echo \"\"
        echo \"📦 Maven Commands:\"
        echo \"  Start: mvn spring-boot:run\"
        echo \"  Install: mvn clean install\"
        echo \"  Test: mvn test\"
        echo \"  Package: mvn clean package\"
    fi
    
    if [ -f \"build.gradle\" ] || [ -f \"build.gradle.kts\" ]; then
        echo \"Build Tool: Gradle\"
        if grep -q \"spring-boot\" build.gradle* 2>/dev/null; then
            echo \"Framework: Spring Boot detected\"
        fi
        echo \"Gradle Version: $(./gradlew --version 2>/dev/null | grep \"Gradle\" | cut -d \" \" -f 2 || gradle --version 2>/dev/null | grep \"Gradle\" | cut -d \" \" -f 2 || echo \"Not installed\")\"
        echo \"\"
        echo \"📦 Gradle Commands:\"
        echo \"  Start: ./gradlew bootRun\"
        echo \"  Install: ./gradlew build\"
        echo \"  Test: ./gradlew test\"
        echo \"  Clean: ./gradlew clean\"
    fi
    echo \"\"
fi

# Python Project Detection
if [ -f \"requirements.txt\" ] || [ -f \"pyproject.toml\" ] || [ -f \"setup.py\" ]; then
    echo \"🐍 PYTHON PROJECT DETECTED:\"
    echo \"Python Version: $(python3 -V 2>/dev/null || python -V 2>/dev/null || echo \"Not installed\")\"
    if [ -f \"requirements.txt\" ]; then
        echo \"Dependencies: requirements.txt found\"
    fi
    if [ -f \"manage.py\" ]; then
        echo \"Framework: Django detected\"
        echo \"\"
        echo \"📦 Django Commands:\"
        echo \"  Start: python manage.py runserver\"
        echo \"  Install: pip install -r requirements.txt\"
        echo \"  Migration: python manage.py migrate\"
    fi
    echo \"\"
fi

echo \"==========================\"
'" in front window
    else
        -- Open in new window if Terminal is not open
        do script "cd " & folderPath & " && bash -c '
echo \"=== PROJECT INFORMATION ===\"
echo \"\"

# Git Information
if [ -d \".git\" ]; then
    echo \"📁 GIT REPOSITORY INFO:\"
    echo \"Branch: $(git branch --show-current 2>/dev/null || echo \"No branch\")\"
    echo \"Repo: $(git remote get-url origin 2>/dev/null || echo \"No remote origin\")\"
    echo \"Last Commit: $(git log -1 --pretty=format:\"%h - %s (%an, %ar)\" 2>/dev/null || echo \"No commits\")\"
    echo \"Commit Date: $(git log -1 --pretty=format:\"%ci\" 2>/dev/null || echo \"N/A\")\"
    echo \"\"
else
    echo \"❌ No git repository found\"
    echo \"\"
fi

# Laravel Project Detection
if [ -f \"artisan\" ] && [ -f \"composer.json\" ]; then
    echo \"🚀 LARAVEL PROJECT DETECTED:\"
    echo \"PHP Version: $(php -v 2>/dev/null | head -n 1 | cut -d \" \" -f 2 || echo \"Not installed\")\"
    echo \"Laravel Version: $(grep \\\"laravel/framework\\\" composer.json | sed \"s/.*\\\"\\\\^\\\\([0-9]*\\\\.[0-9]*\\\\).*/\\\\1/\" || echo \"Unknown\")\"
    echo \"Composer Version: $(composer --version 2>/dev/null | cut -d \" \" -f 3 || echo \"Not installed\")\"
    echo \"\"
    echo \"📦 Laravel Commands:\"
    echo \"  Start: php artisan serve\"
    echo \"  Install: composer install\"
    echo \"  Migration: php artisan migrate\"
    echo \"\"
fi

# Ionic Angular Project Detection
if [ -f \"ionic.config.json\" ] && [ -f \"package.json\" ]; then
    echo \"📱 IONIC ANGULAR PROJECT DETECTED:\"
    echo \"Node Version: $(node -v 2>/dev/null || echo \"Not installed\")\"
    echo \"NPM Version: $(npm -v 2>/dev/null || echo \"Not installed\")\"
    echo \"Ionic Version: $(ionic -v 2>/dev/null || echo \"Not installed globally\")\"
    echo \"Angular Version: $(grep \\\"@angular/core\\\" package.json | sed \"s/.*\\\"\\\\^\\\\([0-9]*\\\\.[0-9]*\\\\).*/\\\\1/\" || echo \"Unknown\")\"
    echo \"\"
    echo \"📦 Ionic Commands:\"
    echo \"  Start: ionic serve\"
    echo \"  Install: npm install\"
    echo \"  Build: ionic build\"
    echo \"\"
fi

# React Project Detection
if [ -f \"package.json\" ] && ! [ -f \"ionic.config.json\" ]; then
    if grep -q \\\"react\\\" package.json; then
        echo \"⚛️  REACT PROJECT DETECTED:\"
        echo \"Node Version: $(node -v 2>/dev/null || echo \"Not installed\")\"
        echo \"NPM Version: $(npm -v 2>/dev/null || echo \"Not installed\")\"
        echo \"React Version: $(grep \\\"react\\\" package.json | sed \"s/.*\\\"\\\\^\\\\([0-9]*\\\\.[0-9]*\\\\).*/\\\\1/\" || echo \"Unknown\")\"
        echo \"\"
        echo \"📦 React Commands:\"
        echo \"  Start: npm start\"
        echo \"  Install: npm install\"
        echo \"  Build: npm run build\"
        echo \"\"
    fi
fi

# Vue Project Detection
if [ -f \"package.json\" ] && ! [ -f \"ionic.config.json\" ]; then
    if grep -q \\\"vue\\\" package.json; then
        echo \"🟢 VUE PROJECT DETECTED:\"
        echo \"Node Version: $(node -v 2>/dev/null || echo \"Not installed\")\"
        echo \"NPM Version: $(npm -v 2>/dev/null || echo \"Not installed\")\"
        echo \"Vue Version: $(grep \\\"vue\\\" package.json | sed \"s/.*\\\"\\\\^\\\\([0-9]*\\\\.[0-9]*\\\\).*/\\\\1/\" || echo \"Unknown\")\"
        echo \"\"
        echo \"📦 Vue Commands:\"
        echo \"  Start: npm run serve\"
        echo \"  Install: npm install\"
        echo \"  Build: npm run build\"
        echo \"\"
    fi
fi

# Java Spring Boot Project Detection
if [ -f \"pom.xml\" ] || [ -f \"build.gradle\" ] || [ -f \"build.gradle.kts\" ]; then
    echo \"☕ JAVA PROJECT DETECTED:\"
    echo \"Java Version: $(java -version 2>&1 | head -n 1 | cut -d \\\"\\\" -f 2 || echo \"Not installed\")\"
    
    if [ -f \"pom.xml\" ]; then
        echo \"Build Tool: Maven\"
        if grep -q \"spring-boot\" pom.xml; then
            echo \"Framework: Spring Boot detected\"
            SPRING_VERSION=$(grep -A 1 \"spring-boot-starter-parent\" pom.xml | grep \"version\" | sed \"s/.*<version>\\\\([^<]*\\\\)<\\/version>.*/\\\\1/\" | head -n 1)
            if [ ! -z \"$SPRING_VERSION\" ]; then
                echo \"Spring Boot Version: $SPRING_VERSION\"
            fi
        fi
        echo \"Maven Version: $(mvn -v 2>/dev/null | head -n 1 | cut -d \" \" -f 3 || echo \"Not installed\")\"
        echo \"\"
        echo \"📦 Maven Commands:\"
        echo \"  Start: mvn spring-boot:run\"
        echo \"  Install: mvn clean install\"
        echo \"  Test: mvn test\"
        echo \"  Package: mvn clean package\"
    fi
    
    if [ -f \"build.gradle\" ] || [ -f \"build.gradle.kts\" ]; then
        echo \"Build Tool: Gradle\"
        if grep -q \"spring-boot\" build.gradle* 2>/dev/null; then
            echo \"Framework: Spring Boot detected\"
        fi
        echo \"Gradle Version: $(./gradlew --version 2>/dev/null | grep \"Gradle\" | cut -d \" \" -f 2 || gradle --version 2>/dev/null | grep \"Gradle\" | cut -d \" \" -f 2 || echo \"Not installed\")\"
        echo \"\"
        echo \"📦 Gradle Commands:\"
        echo \"  Start: ./gradlew bootRun\"
        echo \"  Install: ./gradlew build\"
        echo \"  Test: ./gradlew test\"
        echo \"  Clean: ./gradlew clean\"
    fi
    echo \"\"
fi

# Python Project Detection
if [ -f \"requirements.txt\" ] || [ -f \"pyproject.toml\" ] || [ -f \"setup.py\" ]; then
    echo \"🐍 PYTHON PROJECT DETECTED:\"
    echo \"Python Version: $(python3 -V 2>/dev/null || python -V 2>/dev/null || echo \"Not installed\")\"
    if [ -f \"requirements.txt\" ]; then
        echo \"Dependencies: requirements.txt found\"
    fi
    if [ -f \"manage.py\" ]; then
        echo \"Framework: Django detected\"
        echo \"\"
        echo \"📦 Django Commands:\"
        echo \"  Start: python manage.py runserver\"
        echo \"  Install: pip install -r requirements.txt\"
        echo \"  Migration: python manage.py migrate\"
    fi
    echo \"\"
fi

echo \"==========================\"
'"
    end if
end tell
