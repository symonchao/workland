<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePreparedReportsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('prepared_reports', function (Blueprint $table) {
            $table->increments('id');

            $table->string('name', 100);
            $table->longText('description')
                ->nullable();
            $table->longText('sql_query')
                ->nullable();
            $table->boolean('queue')
                ->default(true)
                ->nullable();
            $table->unsignedInteger('prepared_report_category_id')
                ->index();

            $table->timestamps();

            $table->foreign('prepared_report_category_id')
                ->references('id')
                ->on('prepared_report_categories')
                ->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('prepared_reports');
    }
}
